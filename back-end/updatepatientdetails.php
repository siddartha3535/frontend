<?php
require "dbh.php";

// List of required fields
$requiredFields = ['PatientId', 'username', 'age', 'gender', 'phonenumber', 'emailid', 'Address', 'alcoholic', 'smoker', 'tobacco'];

foreach ($requiredFields as $field) {
    if (!isset($_POST[$field])) {
        echo json_encode(['success' => false, 'message' => "$field is required"]);
        exit();
    }
}

// Extract and sanitize inputs
$PatientId = $conn->real_escape_string($_POST['PatientId']);
$username = $conn->real_escape_string($_POST['username']);
$age = $conn->real_escape_string($_POST['age']);
$gender = $conn->real_escape_string($_POST['gender']);
$phonenumber = $conn->real_escape_string($_POST['phonenumber']);
$emailid = $conn->real_escape_string($_POST['emailid']);
$Address = $conn->real_escape_string($_POST['Address']);
$alcoholic = $conn->real_escape_string($_POST['alcoholic']);
$smoker = $conn->real_escape_string($_POST['smoker']);
$tobacco = $conn->real_escape_string($_POST['tobacco']);

$image = null;
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = 'uploads/';
    $imageName = uniqid() . '_' . basename($_FILES['image']['name']);
    $imagePath = $uploadDir . $imageName;

    if (move_uploaded_file($_FILES['image']['tmp_name'], $imagePath)) {
        $image = $imagePath;
    } else {
        echo json_encode(['success' => false, 'message' => 'Image upload failed']);
        exit();
    }
}

// Build query
$sql = "UPDATE patientlogin SET 
    username = '$username',
    age = '$age',
    gender = '$gender',
    phonenumber = '$phonenumber',
    emailid = '$emailid',
    Address = '$Address',
    alcoholic = '$alcoholic',
    smoker = '$smoker',
    tobacco = '$tobacco'";

if ($image) {
    $sql .= ", image_url = '$image'";
}

$sql .= " WHERE PatientId = '$PatientId'";

// Execute query
if ($conn->query($sql) === TRUE) {
    echo json_encode(['success' => true, 'message' => 'Patient details updated successfully']);
} else {
    echo json_encode(['success' => false, 'message' => $conn->error]);
}

// Close connection
$conn->close();
?>
