<?php
// Include the database connection file
include 'dbh.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['PatientId'])) {
    $patientId = intval($_GET['PatientId']); // Sanitize PatientId input

    $query = "SELECT 
                PatientId, 
                username, 
                age, 
                gender, 
                phonenumber, 
                emailid, 
                Address, 
                alcoholic, 
                smoker, 
                tobacco, 
                CONCAT('$server_ip', image) AS image_url
              FROM 
                patientlogin 
              WHERE 
                PatientId = ?";

    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param('i', $patientId); // Bind the parameter
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $patientData = $result->fetch_assoc();

            // Return the data as JSON
            echo json_encode([
                'status' => 'success',
                'data' => $patientData
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'No patient found with the given ID.'
            ]);
        }

        $stmt->close();
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare the SQL statement.'
        ]);
    }

    $conn->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request. Please provide a valid PatientId.'
    ]);
}
?>
