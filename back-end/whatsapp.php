<?php
// Include the database connection
include('dbh.php');

// SQL query to fetch doctor ID, name, and mobile (WhatsApp) number
$sql = "SELECT `doctorId`, `doctorname`, `mobile` FROM `doctorlogin`";
$result = $conn->query($sql);

// Prepare the response array
$response = array();

// Check if there are results
if ($result->num_rows > 0) {
    // Output data of each row
    while($row = $result->fetch_assoc()) {
        $response[] = array(
            'doctorId' => $row["doctorId"],
            'doctorname' => $row["doctorname"],
            'mobile' => $row["mobile"]
        );
    }
} else {
    $response[] = array('message' => 'No results found');
}

// Set the content type to JSON and return the response
header('Content-Type: application/json');
echo json_encode($response);

// Close the connection
$conn->close();
?>
