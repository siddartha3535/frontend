<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include the database connection file
require 'dbh.php';

// Retrieve data from POST request
$data = $_POST;

// Sanitize input
$patientId = isset($data['patientId']) ? $conn->real_escape_string($data['patientId']) : '';
$name = isset($data['name']) ? $conn->real_escape_string($data['name']) : '';
$age = isset($data['age']) ? $conn->real_escape_string($data['age']) : '';
$gender = isset($data['gender']) ? $conn->real_escape_string($data['gender']) : '';
$phoneNumber = isset($data['phoneNumber']) ? $conn->real_escape_string($data['phoneNumber']) : '';
$emailid = isset($data['emailid']) ? $conn->real_escape_string($data['emailid']) : '';
$address = isset($data['address']) ? $conn->real_escape_string($data['address']) : '';
$password = isset($data['password']) ? $conn->real_escape_string($data['password']) : '';
$alcoholic = isset($data['alcoholic']) ? ($data['alcoholic'] === 'true' ? 'yes' : 'no') : 'no';
$smoker = isset($data['smoker']) ? ($data['smoker'] === 'true' ? 'yes' : 'no') : 'no';
$tobacco = isset($data['tobacco']) ? ($data['tobacco'] === 'true' ? 'yes' : 'no') : 'no';

// Handle image upload if included in form data
$image = null;
if (isset($_FILES['image'])) {
    $file = $_FILES['image'];
    $image_name = $file['name'];
    $image_temp = $file['tmp_name'];
    $image_size = $file['size'];
    $image_type = $file['type'];

    // Validate image type and size
    $allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
    if (!in_array($image_type, $allowed_types)) {
        echo json_encode(["status" => "error", "message" => "Only JPG, PNG, and GIF files are allowed."]);
        exit;
    }

    $max_size = 5 * 1024 * 1024; // 5MB
    if ($image_size > $max_size) {
        echo json_encode(["status" => "error", "message" => "File size exceeds limit. Max allowed size is 5MB."]);
        exit;
    }

    // Generate unique filename
    $image_extension = pathinfo($image_name, PATHINFO_EXTENSION);
    $random_name = uniqid() . '.' . $image_extension;
    $target_dir = "uploads/";
    $target_file = $target_dir . $random_name;

    // Move uploaded image to desired directory
    if (move_uploaded_file($image_temp, $target_file)) {
        $image = $target_file;
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to move uploaded file."]);
        exit;
    }
}

// SQL query to insert data
$sql = "INSERT INTO patientlogin (PatientId, username, age, gender, phonenumber, emailid, Address, password, alcoholic, smoker, tobacco, image)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);

// Check if prepare was successful
if (!$stmt) {
    echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $conn->error]);
    exit;
}

// Bind parameters
$stmt->bind_param("ssssssssssss", $patientId, $name, $age, $gender, $phoneNumber, $emailid, $address, $password, $alcoholic, $smoker, $tobacco, $image);

// Execute the statement
if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "New record created successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $stmt->error]);
}

// Close prepared statement and connection
$stmt->close();
$conn->close();
?>
