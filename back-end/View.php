<?php
header('Content-Type: application/json');

// Include the database connection file
require 'dbh.php'; // This includes the connection and server IP

// Now you can use $conn and $server_ip variables from dbh.php

// Get doctorId from the request
$doctorId = isset($_GET['doctorId']) ? $_GET['doctorId'] : '';

// Prepare SQL query to fetch patients based on doctorId
$sql = "SELECT PatientId, username, image FROM patientlogin WHERE doctorId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $doctorId); // 's' for string
$stmt->execute();
$result = $stmt->get_result();

$patients = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Append base URL (server_ip) to image field
        $row['image'] =  $server_ip . $row['image'];
        $patients[] = $row;
    }
} else {
    // No patients found for the specified doctorId
    $patients = []; // Return an empty array if no patients found
}

$stmt->close();
$conn->close();

// Output the response in JSON format
echo json_encode($patients);
?>
