<?php
// Include the database connection file
require 'dbh.php';

// Check if form was submitted and file is uploaded
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_FILES["video_file"])) {
    // Define the upload directory
    $target_dir = "uploads/";

    // Get form input
    $introduction = $_POST['introduction'] ?? '';
    $custom_file_name = $_POST['custom_file_name'] ?? '';

    // Generate file name
    $video_name = $custom_file_name . "_" . basename($_FILES["video_file"]["name"]);
    $target_file = $target_dir . $video_name;

    $fileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
    $allowedTypes = ['mp4', 'avi', 'mov', 'mkv'];

    if (in_array($fileType, $allowedTypes)) {

        if (move_uploaded_file($_FILES["video_file"]["tmp_name"], $target_file)) {
        

            $sql = "INSERT INTO adddoctorvideos (video_name, video_path, introduction, custom_file_name) VALUES (?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);

            $video_path = $target_file;
            $stmt->bind_param("ssss", $video_name, $video_path, $introduction, $custom_file_name);

            if ($stmt->execute()) {
                echo "Video uploaded successfully.";
            } else {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }

            $stmt->close();
        } else {
            echo "Sorry, there was an error uploading your file.";
        }
    } else {
        echo "Invalid file type. Only MP4, AVI, MOV, and MKV files are allowed.";
    }
}

$conn->close();
?>
