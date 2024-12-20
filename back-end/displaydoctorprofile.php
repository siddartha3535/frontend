<?php
// Include the database connection file
require 'dbh.php';

// Define the doctorId you want to search for
$doctorId = $_GET['doctorId'];

// Prepare and bind
$stmt = $conn->prepare("SELECT `doctorId`, `password`, `doctorname`, `specialization`, `experience`, `age`, `mobile`, `gmail`, `gender`, `image` FROM `doctorlogin` WHERE `doctorId` = ?");
$stmt->bind_param("s", $doctorId);

// Execute the statement
$stmt->execute();

// Bind result variables
$stmt->bind_result($doctorId, $password, $doctorname, $specialization, $experience, $age, $mobile, $gmail, $gender, $image);

// Fetch values
$response = [];
if ($stmt->fetch()) {
    // Use the server_ip variable from dbh.php
    $response = [
        "doctorId" => $doctorId,
        "password" => $password,
        "doctorname" => $doctorname,
        "specialization" => $specialization,
        "experience" => $experience,
        "age" => $age,
        "mobile" => $mobile,
        "gmail" => $gmail,
        "gender" => $gender,
        "image" => $server_ip . $image // Concatenate server IP with image path directly
    ];
}

// Close statement and connection
$stmt->close();
$conn->close();

// Output the response in JSON format
header('Content-Type: application/json');
echo json_encode($response);
?>
