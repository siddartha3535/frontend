<?php
// Include the connection file
include 'dbh.php';

// Function to display the privacy policy content
function display_privacy_policy() {
    echo '<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Privacy Policy - Pulmo Care</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                line-height: 1.6;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }
            .container {
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background: #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1, h2, h3 {
                color: #333;
            }
            p {
                color: #555;
            }
            .chart-section {
                margin-top: 30px;
            }
            .chart-container {
                max-width: 100%;
                height: 400px;
                background-color: #e9e9e9;
                border: 1px solid #ccc;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Privacy Policy</h1>
            <p>Welcome to Pulmo Care, an application dedicated to supporting patients in monitoring and enhancing recovery from lung conditions such as pneumonia. This Privacy Policy describes our practices regarding the collection, use, and protection of your personal information when using our services.</p>
            
            <h2>Interpretation and Definitions</h2>
            <h3>Interpretation</h3>
            <p>Capitalized terms have specific meanings as defined in this document. These definitions apply regardless of their singular or plural forms.</p>
            
            <h3>Definitions</h3>
            <ul>
                <li><strong>Account:</strong> A unique account created for you to access our service.</li>
                <li><strong>Application:</strong> Refers to the Pulmo Care app.</li>
                <li><strong>Service:</strong> The pneumonia recovery and management service offered by the application.</li>
                <li><strong>Patient Data:</strong> Data regarding your health, progress status, charts, and recovery metrics.</li>
                <li><strong>Chart Data:</strong> Visual data generated from recovery tracking tools, including progress graphs and recovery scores.</li>
            </ul>

            <h2>Collection and Use of Your Data</h2>
            <h3>Personal Data</h3>
            <p>We may collect identifiable information from you, including:</p>
            <ul>
                <li>Email address</li>
                <li>Name</li>
                <li>Phone number</li>
                <li>Health data, such as health status, recovery progress, .</li>
            </ul>

            <h2>Usage Data</h2>
            <p>When you access our service, we may collect non-identifiable information automatically, such as IP address, device type, and app usage details, to improve user experience and address technical issues.</p>

            <h2>Health and Chart Data</h2>
            <p>Health data is collected to monitor your recovery progress and provide data visualization through charts. This data is kept secure and is not shared with third parties without explicit consent.</p>

            <h2>Data Sharing</h2>
            <p>Your personal and health-related data is not shared, except to enhance service quality, with your permission, or for legal requirements.</p>

            <h2>Data Retention</h2>
            <p>We retain your data for as long as necessary to deliver our service. Health data may be stored longer to support recovery progress tracking.</p>

            <h2>Data Transfers</h2>
            <p>Your data may be processed outside your country for operational needs, with safeguards in place. By agreeing to this policy, you consent to these transfers and protections.</p>

            <h2>Communication Between Doctors and Patients</h2>
            <p>Our application includes an integrated WhatsApp chat feature, allowing patients and doctors to communicate directly if medical assistance or guidance is required. This feature is especially useful when immediate attention is needed, as doctors can monitor patient results and provide timely support. The contact numbers for both doctors and patients are already configured within the app for secure and seamless communication.</p>

            <h2>Contact Us</h2>
            <p>If you have questions about this Privacy Policy, please contact us at <a href="mailto:sidhukondeti353536@gmail.com">sidhukondeti353536@gmail.com</a>.</p>

            <p>© 2024 Pulmo Care. All rights reserved.</p>
        </div>
    </body>
    </html>';
}

// Call the function to display the privacy policy
display_privacy_policy();
?>
