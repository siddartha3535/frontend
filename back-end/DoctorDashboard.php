<?php
// Set headers to allow cross-origin requests and specify JSON response format
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Include database connection file
require 'dbh.php'; // Ensure this path is correct relative to the main script

// Get the doctor ID from the request
$doctorId = isset($_GET['doctorId']) ? $_GET['doctorId'] : '';

if (empty($doctorId)) {
    // Invalid doctor ID
    $response = array("status" => "error", "message" => "Invalid doctor ID");
    echo json_encode($response);
    exit();
}

// Prepare SQL query to fetch data for the specified doctor
$sql = "SELECT *, CONCAT(?, image) AS image_path FROM patientlogin WHERE doctorId = ? ORDER BY PatientId DESC LIMIT 10";
$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(array("status" => "error", "message" => "Failed to prepare SQL statement"));
    exit();
}

// Use $server_ip from dbh.php as the base URL for image paths
$stmt->bind_param("ss", $server_ip, $doctorId); // Bind the server IP and doctorId
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    // Close statement and connection
    $stmt->close();
    $conn->close();
    
    // Return data array as JSON response
    echo json_encode(array("status" => "success", "data" => $data));
} else {
    // No data found
    $response = array("status" => "error", "message" => "No data found for the specified doctor ID");
    echo json_encode($response);

    // Close statement and connection
    $stmt->close();
    $conn->close();
}
?>
