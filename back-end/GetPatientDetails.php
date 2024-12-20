<?php
header('Content-Type: application/json');

require 'dbh.php'; 

$patientId = isset($_GET['patientId']) ? $_GET['patientId'] : '';

if (empty($patientId)) {
    echo json_encode(["message" => "PatientId is required", "status" => "error"]);
    exit();
}

$sql = "SELECT `PatientId`, `username`, `age`, `gender`, `alcoholic`, `smoker`, `tobacco`, `walk1`, `walk2`, `walk3` FROM `patientlogin` WHERE `PatientId` = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $patientId);
$stmt->execute(); 

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $patient = $result->fetch_assoc(); 
    echo json_encode($patient);
} else {
    echo json_encode(["message" => "Patient not found", "status" => "error"]);
}

$stmt->close();
$conn->close();
?>
