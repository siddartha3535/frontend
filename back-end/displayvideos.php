<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include the database connection file
require 'dbh.php';

// Use the $server_ip from dbh.php for the base URL
$base_url =  $server_ip . "/uploads/";

$sql = "SELECT * FROM adddoctorvideos";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["success" => false, "message" => "Failed to prepare SQL statement"]);
    exit();
}

if (!$stmt->execute()) {
    echo json_encode(["success" => false, "message" => "Failed to execute SQL statement"]);
    exit();
}

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $videos = [];
    while ($row = $result->fetch_assoc()) {
        $file_extension = pathinfo($row['video_name'], PATHINFO_EXTENSION);
        if (in_array($file_extension, ['mp4', 'jpg'])) {
            $row['video_path'] = $base_url . $row['video_name'];
            $videos[] = $row;
        }
    }
    echo json_encode(["success" => true, "data" => $videos]);
} else {
    echo json_encode(["success" => false, "message" => "No videos found"]);
}

$stmt->close();
$conn->close();

?>
