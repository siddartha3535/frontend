<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pulmo_care";

// Manually set the server IP address
$server_ip = 'http://192.168.47.82/pulmo_care/'; 

// Replace with your desired IP address

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);


}
?>
