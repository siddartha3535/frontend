<?php
// prequire.php

// Include the database connection file
require 'dbh.php';

// Fetching data based on PatientId
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['PatientId'])) {
        $patientId = $_GET['PatientId'];

        // Prepare SQL statement
        $sql = "SELECT PatientId, requirement1 FROM requirement WHERE PatientId = ? LIMIT 3";
        $stmt = $conn->prepare($sql);
        
        if ($stmt) {
            $stmt->bind_param("s", $patientId); // Assuming PatientId is a string

            // Execute statement
            if ($stmt->execute()) {
                $result = $stmt->get_result();

                // Fetch result as associative array
                $data = [];
                while ($row = $result->fetch_assoc()) {
                    $data[] = $row;
                }

                // Return JSON response
                header('Content-Type: application/json');
                echo json_encode($data);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Failed to execute statement']);
            }

            // Close statement
            $stmt->close();
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to prepare statement']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Missing PatientId parameter']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Unsupported HTTP method']);
}

// Close connection
$conn->close();
?>
