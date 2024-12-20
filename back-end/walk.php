<?php
// Include the database connection
require 'dbh.php';

// Retrieve the PatientId from the URL query parameters
$patientId = isset($_GET['PatientId']) ? intval($_GET['PatientId']) : 0;

// Check if the PatientId is valid
if ($patientId <= 0) {
    echo json_encode(["error" => "Invalid PatientId"]);
    $conn->close();
    exit;
}

// Prepare the SQL query with a parameterized WHERE clause
$sql = "SELECT `walk1`, `walk2`, `walk3` FROM `patientlogin` WHERE `PatientId` = ?";

// Prepare statement
$stmt = $conn->prepare($sql);

// Check if preparation was successful
if ($stmt === false) {
    echo json_encode(["error" => "Error preparing statement: " . $conn->error]);
    exit;
}

// Bind the parameter
$stmt->bind_param("i", $patientId);

// Execute the query
$stmt->execute();

// Get the result
$result = $stmt->get_result();

// Check if the query returned any results
if ($result->num_rows > 0) {
    $data = $result->fetch_assoc();
    echo json_encode($data);  // Return data as JSON
} else {
    echo json_encode(["error" => "No results found"]);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
