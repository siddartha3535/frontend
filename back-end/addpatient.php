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
$data = $_POST; // Use $_POST for form data

$patientId = $data['patientId'];
$name = $data['name'];
$age = $data['age'];
$gender = $data['gender'];
$phoneNumber = $data['phoneNumber'];
$emailid = $data['emailid'];
$address = $data['address'];
$password = $data['password'];
$alcoholic = isset($data['alcoholic']) ? ($data['alcoholic'] === 'true' ? 'yes' : 'no') : 'no';
$smoker = isset($data['smoker']) ? ($data['smoker'] === 'true' ? 'yes' : 'no') : 'no';
$tobacco = isset($data['tobacco']) ? ($data['tobacco'] === 'true' ? 'yes' : 'no') : 'no';
$doctorId = $data['doctorId']; // Assuming doctorId is passed from frontend

// Handle image upload
$image = $_FILES['image']; // Assuming the form input name is 'image'

if ($image['error'] === 0) {
    $imageName = basename($image['name']);
    $imageTmpName = $image['tmp_name'];
    $imageSize = $image['size'];

    // Validate image type by checking MIME type (to ensure it's an image)
    $allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/bmp', 'image/svg+xml'];

    $imageMimeType = mime_content_type($imageTmpName);
    
    if (in_array($imageMimeType, $allowedMimeTypes)) {
        if ($imageSize <= 5000000) { // Limit file size to 5MB
            $uploadDir = 'uploads/';
            $imagePath = $uploadDir . uniqid('', true) . '.' . pathinfo($imageName, PATHINFO_EXTENSION); // Unique image name

            if (move_uploaded_file($imageTmpName, $imagePath)) {
                // Image successfully uploaded
                $imageUrl = $imagePath; // Path to the image file for storing in DB
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to upload image"]);
                exit;
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Image file size is too large"]);
            exit;
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid image file type"]);
        exit;
    }
} else {
    // If no image is uploaded, set $imageUrl to a default value or leave it empty
    $imageUrl = null;
}

// SQL query to insert data
$sql = "INSERT INTO patientlogin (PatientId, username, age, gender, phonenumber, emailid, Address, password, alcoholic, smoker, tobacco, doctorId, image)
        VALUES ('$patientId', '$name', '$age', '$gender', '$phoneNumber', '$emailid', '$address', '$password', '$alcoholic', '$smoker', '$tobacco', '$doctorId', '$imageUrl')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "New record created successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $sql . "<br>" . $conn->error]);
}

$conn->close();
?>
