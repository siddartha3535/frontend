<?php
header('Content-Type: application/json');

// Include the database connection
require 'dbh.php';

// Get the patientId from the request
$patientId = isset($_GET['patientId']) ? intval($_GET['patientId']) : 0;

if ($patientId <= 0) {
    die(json_encode(array("status" => "error", "message" => "Invalid patientId.")));
}

// Prepare SQL query to get walk1, walk2, walk3 details
$stmt = $conn->prepare("SELECT walk1, walk2, walk3 FROM patientlogin WHERE PatientId = ?");
$stmt->bind_param("i", $patientId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $details = $result->fetch_assoc();
    $response = array("status" => "success", "data" => $details);
} else {
    $response = array("status" => "error", "message" => "No patient found with the given ID.");
}

$stmt->close();
$conn->close();

echo json_encode($response);
?>
