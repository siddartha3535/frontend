<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, Accept");
header("Access-Control-Allow-Credentials: true");
if ($_SERVER["REQUEST_METHOD"] == "OPTIONS") {
    http_response_code(200);
    exit;
}

// Start session
session_start();

// Set content type to JSON
header('Content-Type: application/json');

// Include database connection
require 'dbh.pp'; 

// Function to authenticate user
function authenticateUser($username, $password, $conn) {
    $sql = "SELECT `id`, `name`, `password`, `role_id` FROM `users` WHERE `name` = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        $user = $result->fetch_assoc();
        if (password_verify($password, $user['password'])) {
            return $user;
        }
    }
    return null;
}

// Handle POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the raw JSON data from the request body
    $data = file_get_contents('php://input');
    $decodedData = json_decode($data, true);

    // Check if username and password are provided in JSON format
    if (isset($decodedData['username']) && isset($decodedData['password'])) {
        // Retrieve username and password
        $username = $decodedData['username'];
        $password = $decodedData['password'];

        // Authenticate user
        $user = authenticateUser($username, $password, $conn);

        if ($user) {
            // Password is correct, set session variables and prepare JSON response
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['role_id'] = $user['role_id'];
            $response = array("success" => true, "redirect" => "dashboard.php");
        } else {
            $response = array("success" => false, "message" => "Invalid username or password");
        }
    } else {
        $response = array("success" => false, "message" => "Username or password not provided");
    }
    
    echo json_encode($response);
    exit;
}

// Handle GET request for logout
if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET['action']) && $_GET['action'] == "logout") {
    // Check if user is logged in
    if (isset($_SESSION['role_id'])) {
        // Unset session variables and destroy session
        session_unset();
        session_destroy();
        $response = array("success" => true, "redirect" => "index.php");
    } else {
        $response = array("success" => false, "message" => "Not logged in");
    }
    
    echo json_encode($response);
    exit;
}

// Default response for other cases
$response = array("success" => false, "message" => "Invalid request");
echo json_encode($response);
exit;
?>
