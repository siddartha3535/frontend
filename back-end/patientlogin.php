<?php

include 'dbh.php';

// Get patientid and password from POST request
$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$patientid = $request->PatientId; // Adjust to uppercase PatientId
$password = $request->password;

// Protect against SQL injection
$patientid = mysqli_real_escape_string($conn, $patientid);

// Check if the patientid exists in the database
$sql = "SELECT * FROM patientlogin WHERE PatientId = '$patientid'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Patientid exists, now check password
    $row = $result->fetch_assoc();
    if ($password == $row['password']) {
        // Password is correct
        $response = array(
            'status' => 'success',
            'message' => 'Login successful',
            'username' => $row['username']
        );
    } else {
        // Password is incorrect
        $response = array(
            'status' => 'error',
            'message' => 'Incorrect password'
        );
    }
} else {
    // Patientid doesn't exist
    $response = array(
        'status' => 'error',
        'message' => 'Patient ID not found'
    );
}

// Close database connection
$conn->close();

// Send response back to client
header('Content-Type: application/json');
echo json_encode($response);
?>
