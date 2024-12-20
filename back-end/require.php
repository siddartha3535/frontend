<?php
// Include the separate database connection file
require 'dbh.php';

// Receive POST data
$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

if (isset($request->patientId) && isset($request->requirement1)) {
    $patientId = $request->patientId;
    $requirement1 = $request->requirement1;

    // Prepare SQL statement to insert data
    $sql = "INSERT INTO requirement (PatientId, requirement1) VALUES (?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("is", $patientId, $requirement1);

    // Execute SQL statement
    if ($stmt->execute()) {
        $response = array(
            "status" => "success",
            "message" => "Requirement saved successfully."
        );
    } else {
        $response = array(
            "status" => "error",
            "message" => "Failed to save requirement: " . $conn->error
        );
    }

    // Close statement
    $stmt->close();
} else {
    $response = array(
        "status" => "error",
        "message" => "Missing patientId or requirement1 in request."
    );
}

// Close connection
$conn->close();

// Output JSON response
header('Content-Type: application/json');
echo json_encode($response);

?>
