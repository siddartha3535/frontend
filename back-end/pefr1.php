<?php
// Include the database connection file
require 'dbh.php';

header('Content-Type: application/json');

// Fetching peakflow data based on patientId
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['patientId'])) {
        $patientId = $_GET['patientId'];

        // Prepare SQL statement
        $sql = "SELECT PatientId, Date, Time, PEFR FROM peakflow WHERE PatientId = ? LIMIT 3";
        $stmt = $conn->prepare($sql);
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
            echo json_encode($data);
        } else {
            // Handle SQL execution error
            echo json_encode(['status' => 'error', 'message' => 'SQL execution failed']);
        }
    } else {
        // Handle missing patientId parameter
        echo json_encode(['status' => 'error', 'message' => 'Missing patientId parameter']);
    }
} else {
    // Handle unsupported HTTP method
    echo json_encode(['status' => 'error', 'message' => 'Unsupported HTTP method']);
}

// Close connection
$stmt->close();
$conn->close();
?>
