<?php

// Include the database connection file
require 'dbh.php';

// Get POST data
$postData = file_get_contents("php://input");
$request = json_decode($postData);

if (isset($request->screen)) {
    $screen = $request->screen;

    if (isset($request->videos) && is_array($request->videos)) {
        $videos = $request->videos;
        
        // Adjust table name based on screen
        $tableName = '';
        switch ($screen) {
            case 'V1':
                $tableName = 'screenv1'; // Replace with your actual table name for V1
                break;
            case 'V2':
                $tableName = 'screenv2'; // Replace with your actual table name for V2
                break;
            case 'V3':
                $tableName = 'screenv3'; // Replace with your actual table name for V3
                break;
            case 'V4':
                $tableName = 'screenv4'; // Replace with your actual table name for V4
                break;
            default:
                $tableName = 'default_table'; // Handle default case or error
                break;
        }

        // Prepare and bind SQL statement
        $stmt = $conn->prepare("INSERT INTO $tableName (video_name, video_path, introduction, custom_file_name, upload_time) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss", $video_name, $video_path, $introduction, $custom_file_name, $upload_time);

        foreach ($videos as $video) {
            $video_name = $video->video_name;
            $video_path = $video->video_path;
            $introduction = $video->introduction;
            $custom_file_name = $video->custom_file_name;
            $upload_time = date('Y-m-d H:i:s'); // Adjust based on your database schema

            // Execute the prepared statement
            $stmt->execute();
        }

        $stmt->close();
        $conn->close();

        // Return success response to the client
        $response = array("success" => true, "message" => "Videos stored successfully for $screen.");
        echo json_encode($response);
    } else {
        // Return error response if videos array is missing or invalid
        $response = array("success" => false, "message" => "Invalid request data.");
        echo json_encode($response);
    }
} else {
    // Return error response if screen parameter is missing
    $response = array("success" => false, "message" => "Screen parameter is required.");
    echo json_encode($response);
}
?>
