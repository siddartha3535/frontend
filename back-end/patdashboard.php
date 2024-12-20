<?php
header('Content-Type: application/json');

// Include the database connection file
require 'dbh.php';

// Fetch patient ID from URL parameter
$patient_id = isset($_GET['patient_id']) ? intval($_GET['patient_id']) : 0;

// Validate patient ID
if ($patient_id <= 0) {
    echo json_encode(["message" => "Invalid patient ID"]);
    exit();
}

// Prepare SQL query to fetch patient details
$sql = "SELECT * FROM patientdetails WHERE id = ?";
$stmt = $conn->prepare($sql);

// Check if prepare was successful
if (!$stmt) {
    echo json_encode(['error' => 'Prepare failed: ' . $conn->error]);
    exit();
}

// Bind parameter and execute query
$stmt->bind_param("i", $patient_id);
$stmt->execute();

// Get result
$result = $stmt->get_result();

// Check if there are rows returned
if ($result->num_rows > 0) {
    // Fetch associative array
    $patient_details = $result->fetch_assoc();
    echo json_encode($patient_details);
} else {
    // If no rows found, return a message
    echo json_encode(["message" => "No patient found"]);
}

// Close prepared statement and connection
$stmt->close();
$conn->close();
?>
