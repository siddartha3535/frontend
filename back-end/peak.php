<?php
// Include the database connection file
require 'dbh.php';

header("Content-Type: application/json");

// Handle POST request to save PEFR value
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get JSON input
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if JSON decoding was successful
    if (json_last_error() === JSON_ERROR_NONE) {
        // Extract values from JSON input
        $PatientId = $data['PatientId'] ?? null;
        $pefrValue = $data['pefr'] ?? null;
        $date = $data['date'] ?? null;
        $time = $data['time'] ?? null;

        // Validate required fields
        if ($PatientId && $pefrValue && $date && $time) {
            // Prepare SQL statement to insert the record
            $sql = "INSERT INTO peakflow (PatientId, date, time, pefr) VALUES (?, ?, ?, ?)";

            // Prepare and bind parameters
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("isss", $PatientId, $date, $time, $pefrValue);

            // Execute the statement
            if ($stmt->execute()) {
                echo json_encode(["status" => "success", "message" => "PEFR value inserted successfully."]);
            } else {
                echo json_encode(["status" => "error", "message" => "Error: " . $stmt->error]);
            }

            // Close statement
            $stmt->close();
        } else {
            echo json_encode(["status" => "error", "message" => "Error: Missing required fields."]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Error: JSON decoding failed - " . json_last_error_msg()]);
    }
}

// Close connection
$conn->close();
?>
