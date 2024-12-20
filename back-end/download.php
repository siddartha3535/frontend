<?php
// Include the database connection file
require_once('dbh.php');

// Hardcode the table and query
$query = "
    SELECT 
        p.`PatientId`, 
        p.`username`, 
        p.`age`, 
        p.`gender`, 
        p.`phonenumber`, 
        p.`emailid`, 
        p.`Address`, 
        p.`password`, 
        p.`alcoholic`, 
        p.`smoker`, 
        p.`tobacco`, 
        p.`image`, 
        p.`doctorId`, 
        p.`walk1`, 
        p.`walk2`, 
        p.`walk3`, 
        p.`requirement`, 
        p.`walk1_updated`, 
        p.`walk2_updated`, 
        p.`walk3_updated`, 
        p.`all_updated`, 
        pf.`pefr` -- Adding the PEFR value from peakflow
    FROM 
        `patientlogin` p
    LEFT JOIN 
        `peakflow` pf 
    ON 
        p.`PatientId` = pf.`PatientId`"; // Join based on PatientId

$filename = "patientlogin_with_pefr.csv";  // Set filename for download

// Set the headers to force the browser to download the file
header('Content-Type: text/csv; charset=utf-8');
header("Content-Disposition: attachment; filename=\"$filename\"");

// Open the output stream
$output = fopen('php://output', 'w');

// Execute the query
$result = $conn->query($query);

// Check if the query executed successfully
if ($result && $result->num_rows > 0) {
    // Fetch the field names (column headers) from the first row
    $fields = $result->fetch_fields();
    $header = [];
    foreach ($fields as $field) {
        $header[] = $field->name; // Get the column name
    }

    // Write the column headers to the CSV file
    fputcsv($output, $header);

    // Write the data rows to the CSV file
    while ($row = $result->fetch_assoc()) {
        fputcsv($output, $row); // Write each row
    }
} else {
    // No data found for the query
    echo "No data found.";
}

// Close the output stream
fclose($output);

// Close the database connection
$conn->close();
?>
