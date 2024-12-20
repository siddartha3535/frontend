<?php
require "dbh.php";

// Check if POST variables are set
if (isset($_POST['doctorId'], $_POST['doctorname'], $_POST['mobile'], $_POST['gender'], $_POST['age'], $_POST['experience'], $_POST['specialization'], $_POST['password'], $_POST['confirmpassword'], $_POST['gmail'])) {
    // Extract and sanitize values from POST
    $doctorId = $conn->real_escape_string($_POST['doctorId']);
    $doctorname = $conn->real_escape_string($_POST['doctorname']);
    $mobile = $conn->real_escape_string($_POST['mobile']);
    $gender = $conn->real_escape_string($_POST['gender']);
    $age = $conn->real_escape_string($_POST['age']);
    $experience = $conn->real_escape_string($_POST['experience']);
    $specialization = $conn->real_escape_string($_POST['specialization']);
    $password = $conn->real_escape_string($_POST['password']);
    $confirmpassword = $conn->real_escape_string($_POST['confirmpassword']);
    $gmail = $conn->real_escape_string($_POST['gmail']);

    // Check if passwords match
    if ($password !== $confirmpassword) {
        $response = [
            'success' => false,
            'message' => 'Error: Passwords do not match.'
        ];
        echo json_encode($response);
        exit();
    }

    // Initialize $sql variable
    $sql = "";

    // Check if image file is uploaded
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        // Specify the directory for storing the uploaded images
        $uploadDir = "uploads/";

        // Get the temporary filename of the uploaded file
        $tempFilename = $_FILES['image']['tmp_name'];

        // Generate a unique filename for the uploaded image
        $newFilename = uniqid() . '_' . basename($_FILES['image']['name']);

        // Move the uploaded file to the specified directory with the new filename
        if (move_uploaded_file($tempFilename, $uploadDir . $newFilename)) {
            // Get the existing image filename for the doctor
            $getImageSql = "SELECT image FROM doctorlogin WHERE doctorId = '$doctorId'";
            $result = $conn->query($getImageSql);
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $existingImage = $row["image"];
                // Delete the existing image file if it exists
                if (file_exists($existingImage)) {
                    unlink($existingImage);
                }
            }
            // Update the image field in the database with the new filename
            $image = $uploadDir . $newFilename;
            $sql = "UPDATE doctorlogin SET 
                        doctorname = '$doctorname', 
                        mobile = '$mobile', 
                        gender = '$gender', 
                        age = '$age', 
                        experience = '$experience', 
                        specialization = '$specialization', 
                        password = '$password', 
                        gmail = '$gmail', 
                        image = '$image' 
                    WHERE doctorId = '$doctorId'";
        } else {
            // Error moving uploaded file
            $response = [
                'success' => false,
                'message' => 'Error: Failed to move uploaded file.'
            ];
            echo json_encode($response);
            exit();
        }
    } else {
        // If image file is not uploaded or an error occurred, proceed without updating the image field
        $sql = "UPDATE doctorlogin SET 
                    doctorname = '$doctorname', 
                    mobile = '$mobile', 
                    gender = '$gender', 
                    age = '$age', 
                    experience = '$experience', 
                    specialization = '$specialization', 
                    password = '$password', 
                    gmail = '$gmail' 
                WHERE doctorId = '$doctorId'";
    }

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        // Data updated successfully
        $response = [
            'success' => true,
            'message' => 'Doctor details updated successfully'
        ];
        echo json_encode($response);
    } else {
        // Error updating data
        $response = [
            'success' => false,
            'message' => 'Error: ' . $conn->error
        ];
        echo json_encode($response);
    }
} else {
    // If POST variables are not set, echo an error message
    $response = [
        'success' => false,
        'message' => 'Error: Required POST variables are not set'
    ];
    echo json_encode($response);
}

// Close connection
$conn->close();
?>
