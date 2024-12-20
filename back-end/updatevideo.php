<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Include the database connection and server IP
    require 'dbh.php';

    // Retrieve POST request parameters
    $id = isset($_POST['id']) ? $_POST['id'] : '';
    $introduction = isset($_POST['introduction']) ? $_POST['introduction'] : '';
    $custom_file_name = isset($_POST['custom_file_name']) ? $_POST['custom_file_name'] : '';

    // Validate required parameters
    if (empty($id) || empty($introduction) || empty($custom_file_name)) {
        echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
        exit();
    }

    // Define base URL using $server_ip from dbh.php
    $baseurl =  "uploads/"; // Ensure 'uploads/' directory is correct

    // Check if file is uploaded
    if (isset($_FILES["video_file"])) {
        // Define upload directory
        $target_dir = "uploads/";

        // Get the file extension
        $file_extension = pathinfo($_FILES["video_file"]["name"], PATHINFO_EXTENSION);

        // Validate file extension (case-insensitive)
        if (!in_array(strtolower($file_extension), ['mp4'])) {
            echo json_encode(["status" => "error", "message" => "Invalid file type. Only MP4 files are allowed."]);
            exit();
        }

        // Generate file name with extension
        $video_name = $custom_file_name . "_" . basename($_FILES["video_file"]["name"]);
        $target_file = $target_dir . $video_name;

        // Move uploaded file to the target directory
        if (move_uploaded_file($_FILES["video_file"]["tmp_name"], $target_file)) {
            // File uploaded successfully, update database
            $video_path = $baseurl . $video_name; // Constructed file path

            // Prepare SQL update statement with video_path
            $sql = "UPDATE adddoctorvideos SET video_name = ?, video_path = ?, introduction = ?, custom_file_name = ? WHERE id = ?";
            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                echo json_encode(["status" => "error", "message" => "Failed to prepare SQL statement: " . $conn->error]);
                $conn->close();
                exit();
            }

            // Bind parameters and execute update
            $stmt->bind_param("ssssi", $video_name, $video_path, $introduction, $custom_file_name, $id);

            if ($stmt->execute()) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Record updated successfully.",
                    "file_path" => $video_path
                ]);
            } else {
                echo json_encode(["status" => "error", "message" => "Error executing SQL statement: " . $stmt->error]);
            }

            $stmt->close();
        } else {
            // Error uploading file
            echo json_encode(["status" => "error", "message" => "Sorry, there was an error uploading your file."]);
        }
    } else {
        // No file uploaded, update only other parameters
        $sql = "UPDATE adddoctorvideos SET introduction = ?, custom_file_name = ? WHERE id = ?";
        $stmt = $conn->prepare($sql);

        if (!$stmt) {
            echo json_encode(["status" => "error", "message" => "Failed to prepare SQL statement: " . $conn->error]);
            $conn->close();
            exit();
        }

        // Bind parameters and execute update
        $stmt->bind_param("ssi", $introduction, $custom_file_name, $id);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Record updated successfully."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Error executing SQL statement: " . $stmt->error]);
        }

        $stmt->close();
    }

    $conn->close();
} else {
    // Invalid request method
    echo json_encode(["status" => "error", "message" => "Invalid request method. Only POST method is allowed."]);
}
?>
