<?php
// Include the separate database connection file
require 'dbh.php';

header('Content-Type: application/json');

// Fetch input data
$input_data = json_decode(file_get_contents('php://input'), true);

// Validate that the required `patientId` is provided
if (!isset($input_data['patientId'])) {
    die(json_encode(array("status" => "error", "message" => "Missing patientId.")));
}

$patientId = $input_data['patientId'];
$walk1 = isset($input_data['walk1']) ? $input_data['walk1'] : null;
$walk2 = isset($input_data['walk2']) ? $input_data['walk2'] : null;
$walk3 = isset($input_data['walk3']) ? $input_data['walk3'] : null;

$response = array("status" => "error", "message" => "No valid data provided for update.");

// Check if walk1, walk2, or walk3 already have data
$stmt = $conn->prepare("SELECT walk1, walk2, walk3 FROM patientlogin WHERE PatientId = ?");
$stmt->bind_param("i", $patientId);
$stmt->execute();
$result = $stmt->get_result();
$patientData = $result->fetch_assoc();

if ($patientData) {
    // Check if walk1 already has data
    if ($walk1 && !$patientData['walk1']) {
        $stmt = $conn->prepare("UPDATE patientlogin SET walk1 = ? WHERE PatientId = ?");
        $stmt->bind_param("si", $walk1, $patientId);
        if ($stmt->execute()) {
            $response = array("status" => "success", "message" => "Walk1 updated successfully.");
        }
        $stmt->close();
    } elseif ($walk1 && $patientData['walk1']) {
        $response = array("status" => "error", "message" => "Walk1 already has data.");
    }

    // Check if walk2 already has data
    if ($walk2 && !$patientData['walk2']) {
        $stmt = $conn->prepare("UPDATE patientlogin SET walk2 = ? WHERE PatientId = ?");
        $stmt->bind_param("si", $walk2, $patientId);
        if ($stmt->execute()) {
            $response = array("status" => "success", "message" => "Walk2 updated successfully.");
        }
        $stmt->close();
    } elseif ($walk2 && $patientData['walk2']) {
        $response = array("status" => "error", "message" => "Walk2 already has data.");
    }

    // Check if walk3 already has data
    if ($walk3 && !$patientData['walk3']) {
        $stmt = $conn->prepare("UPDATE patientlogin SET walk3 = ? WHERE PatientId = ?");
        $stmt->bind_param("si", $walk3, $patientId);
        if ($stmt->execute()) {
            $response = array("status" => "success", "message" => "Walk3 updated successfully.");
        }
        $stmt->close();
    } elseif ($walk3 && $patientData['walk3']) {
        $response = array("status" => "error", "message" => "Walk3 already has data.");
    }
} else {
    $response = array("status" => "error", "message" => "No patient found with this ID.");
}

// Close the database connection
$conn->close();

// Return the response
echo json_encode($response);
?>
