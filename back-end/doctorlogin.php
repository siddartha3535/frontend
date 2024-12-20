<?php

require 'dbh.php'; // Include the database connection file

// Get doctorId and password from POST request
$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$doctorId = isset($request->doctorId) ? $request->doctorId : '';
$password = isset($request->password) ? $request->password : '';

// Protect against SQL injection
$doctorId = mysqli_real_escape_string($conn, $doctorId);

// Check if the doctorId exists in the database
$sql = "SELECT * FROM doctorlogin WHERE doctorId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $doctorId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // doctorId exists, now check password
    $row = $result->fetch_assoc();
    if ($password == $row['password']) {
        // Password is correct
        $response = array(
            'status' => 'success',
            'message' => 'Login successful',
            'doctorname' => $row['doctorname'] // Include doctorname in the response
        );
    } else {
        // Password is incorrect
        $response = array(
            'status' => 'error',
            'message' => 'Incorrect password'
        );
    }
} else {
    // doctorId doesn't exist
    $response = array(
        'status' => 'error',
        'message' => 'DoctorId not found'
    );
}

// Close database connection
$stmt->close();
$conn->close();

// Send response back to client
header('Content-Type: application/json');
echo json_encode($response);
?>
