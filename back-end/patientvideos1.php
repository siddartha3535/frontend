<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Include database connection file, which contains $server_ip
require 'dbh.php';

// Base URL for videos, using the server IP from dbh.php
$base_url = $server_ip . "uploads/";
// Select the latest videos only
$sql = "SELECT id, video_name, video_path, introduction, custom_file_name, upload_time FROM screenv2 ORDER BY upload_time DESC LIMIT 3";
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
        $file_extension = strtolower(pathinfo($row['video_name'], PATHINFO_EXTENSION));
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
