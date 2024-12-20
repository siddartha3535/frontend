-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 16, 2024 at 10:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pulmonary`
--

-- --------------------------------------------------------

--
-- Table structure for table `adddoctorvideos`
--

CREATE TABLE `adddoctorvideos` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text NOT NULL,
  `custom_file_name` varchar(255) NOT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adddoctorvideos`
--

INSERT INTO `adddoctorvideos` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `upload_time`) VALUES
(3, 'v1_1000027647.mp4', 'uploads/v1_1000027647.mp4', 'v1', 'v1', '2024-12-16 04:14:10'),
(5, 'v2_1000027645.mp4', 'uploads/v2_1000027645.mp4', 'v2', 'v2', '2024-12-16 04:14:54'),
(6, 'v3_1000027648.mp4', 'uploads/v3_1000027648.mp4', 'v3', 'v3', '2024-12-16 04:15:48'),
(7, 'v4_1000027649.mp4', 'uploads/v4_1000027649.mp4', 'v4', 'v4', '2024-12-16 04:16:33'),
(8, 'v5_1000027650.mp4', 'uploads/v5_1000027650.mp4', 'v5', 'v5', '2024-12-16 04:18:11'),
(9, 'v6_1000027651.mp4', 'uploads/v6_1000027651.mp4', 'v6', 'v6', '2024-12-16 04:18:40'),
(10, 'v7_1000027652.mp4', 'uploads/v7_1000027652.mp4', 'v7', 'v7', '2024-12-16 04:20:04'),
(11, 'v8_1000027653.mp4', 'uploads/v8_1000027653.mp4', 'v8', 'v8', '2024-12-16 04:20:38'),
(12, 'v9_1000027654.mp4', 'uploads/v9_1000027654.mp4', 'v9', 'v9', '2024-12-16 04:22:43'),
(14, 'v10_1000027655.mp4', 'uploads/v10_1000027655.mp4', 'v10', 'v10', '2024-12-16 04:23:54'),
(15, 'v11_1000027656.mp4', 'uploads/v11_1000027656.mp4', 'v11', 'v11', '2024-12-16 04:25:15'),
(16, 'v12_1000027657.mp4', 'uploads/v12_1000027657.mp4', 'v12', 'v12', '2024-12-16 04:26:35'),
(17, 'v13_1000027658.mp4', 'uploads/v13_1000027658.mp4', 'v13', 'v13', '2024-12-16 04:30:25');

-- --------------------------------------------------------

--
-- Table structure for table `doctorlogin`
--

CREATE TABLE `doctorlogin` (
  `doctorId` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `doctorname` varchar(100) DEFAULT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `experience` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `gmail` varchar(100) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `gender` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctorlogin`
--

INSERT INTO `doctorlogin` (`doctorId`, `password`, `doctorname`, `specialization`, `experience`, `age`, `mobile`, `gmail`, `image`, `gender`) VALUES
('123', '69420', 'DR.D.Radhika ', 'pulmonologist', 20, 40, '8341388963', 'Hari@gmail.com', 'uploads/66a0d2db3e356.jpg', 'Male');

-- --------------------------------------------------------

--
-- Table structure for table `doctortable`
--

CREATE TABLE `doctortable` (
  `doctorId` int(11) NOT NULL,
  `doctorname` varchar(255) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `age` int(11) NOT NULL,
  `experience` int(11) NOT NULL,
  `specialization` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `confirmpassword` varchar(255) NOT NULL,
  `gmail` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patientlogin`
--

CREATE TABLE `patientlogin` (
  `PatientId` varchar(30) NOT NULL,
  `username` varchar(20) NOT NULL,
  `age` int(20) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `phonenumber` varchar(100) NOT NULL,
  `emailid` varchar(600) NOT NULL,
  `Address` varchar(200) NOT NULL,
  `password` varchar(20) NOT NULL,
  `alcoholic` varchar(20) NOT NULL,
  `smoker` varchar(20) NOT NULL,
  `tobacco` varchar(20) NOT NULL,
  `image` varchar(100) NOT NULL,
  `doctorId` varchar(20) NOT NULL,
  `walk1` varchar(200) NOT NULL,
  `walk2` varchar(200) NOT NULL,
  `walk3` varchar(200) NOT NULL,
  `requirement` varchar(300) NOT NULL,
  `walk1_updated` tinyint(1) DEFAULT 0,
  `walk2_updated` tinyint(1) DEFAULT 0,
  `walk3_updated` tinyint(1) DEFAULT 0,
  `all_updated` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientlogin`
--

INSERT INTO `patientlogin` (`PatientId`, `username`, `age`, `gender`, `phonenumber`, `emailid`, `Address`, `password`, `alcoholic`, `smoker`, `tobacco`, `image`, `doctorId`, `walk1`, `walk2`, `walk3`, `requirement`, `walk1_updated`, `walk2_updated`, `walk3_updated`, `all_updated`) VALUES
('1111', 'Sidhu ', 21, 'male', '8341388963', 'hari@gmail.com', 'rajampet', '1111', 'yes', 'yes', 'yes', 'uploads/675fa503672495.18911837.jpg', '123', '123', '', '', '', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `peakflow`
--

CREATE TABLE `peakflow` (
  `PatientId` varchar(20) NOT NULL,
  `date` varchar(20) NOT NULL,
  `time` varchar(20) NOT NULL,
  `pefr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peakflow`
--

INSERT INTO `peakflow` (`PatientId`, `date`, `time`, `pefr`) VALUES
('1111', '2024-12-16', '10:5', '369');

-- --------------------------------------------------------

--
-- Table structure for table `requirement`
--

CREATE TABLE `requirement` (
  `PatientId` varchar(20) NOT NULL,
  `requirement1` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requirement`
--

INSERT INTO `requirement` (`PatientId`, `requirement1`) VALUES
('1111', 'hiiii');

-- --------------------------------------------------------

--
-- Table structure for table `screenv1`
--

CREATE TABLE `screenv1` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text DEFAULT NULL,
  `custom_file_name` varchar(255) DEFAULT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `screenv1`
--

INSERT INTO `screenv1` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `upload_time`) VALUES
(1, 'v1_1000027647.mp4', 'http://192.168.47.82/pulmonary//uploads/v1_1000027647.mp4', 'v1', 'v1', '2024-12-16 00:01:10'),
(2, 'v2_1000027645.mp4', 'http://192.168.47.82/pulmonary//uploads/v2_1000027645.mp4', 'v2', 'v2', '2024-12-16 00:01:10'),
(3, 'v3_1000027648.mp4', 'http://192.168.47.82/pulmonary//uploads/v3_1000027648.mp4', 'v3', 'v3', '2024-12-16 00:01:10');

-- --------------------------------------------------------

--
-- Table structure for table `screenv2`
--

CREATE TABLE `screenv2` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text DEFAULT NULL,
  `custom_file_name` varchar(255) DEFAULT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `screenv2`
--

INSERT INTO `screenv2` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `upload_time`) VALUES
(1, 'v4_1000027649.mp4', 'http://192.168.47.82/pulmonary//uploads/v4_1000027649.mp4', 'v4', 'v4', '2024-12-16 00:02:25'),
(2, 'v5_1000027650.mp4', 'http://192.168.47.82/pulmonary//uploads/v5_1000027650.mp4', 'v5', 'v5', '2024-12-16 00:02:25'),
(3, 'v6_1000027651.mp4', 'http://192.168.47.82/pulmonary//uploads/v6_1000027651.mp4', 'v6', 'v6', '2024-12-16 00:02:25');

-- --------------------------------------------------------

--
-- Table structure for table `screenv3`
--

CREATE TABLE `screenv3` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text DEFAULT NULL,
  `custom_file_name` varchar(255) DEFAULT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `screenv3`
--

INSERT INTO `screenv3` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `upload_time`) VALUES
(1, 'v7_1000027652.mp4', 'http://192.168.47.82/pulmonary//uploads/v7_1000027652.mp4', 'v7', 'v7', '2024-12-16 00:02:44'),
(2, 'v8_1000027653.mp4', 'http://192.168.47.82/pulmonary//uploads/v8_1000027653.mp4', 'v8', 'v8', '2024-12-16 00:02:44'),
(3, 'v9_1000027654.mp4', 'http://192.168.47.82/pulmonary//uploads/v9_1000027654.mp4', 'v9', 'v9', '2024-12-16 00:02:44');

-- --------------------------------------------------------

--
-- Table structure for table `screenv4`
--

CREATE TABLE `screenv4` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text DEFAULT NULL,
  `custom_file_name` varchar(255) DEFAULT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `screenv4`
--

INSERT INTO `screenv4` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `upload_time`) VALUES
(1, 'v10_1000027655.mp4', 'http://192.168.47.82/pulmonary//uploads/v10_1000027655.mp4', 'v10', 'v10', '2024-12-16 00:03:28'),
(2, 'v11_1000027656.mp4', 'http://192.168.47.82/pulmonary//uploads/v11_1000027656.mp4', 'v11', 'v11', '2024-12-16 00:03:28'),
(3, 'v12_1000027657.mp4', 'http://192.168.47.82/pulmonary//uploads/v12_1000027657.mp4', 'v12', 'v12', '2024-12-16 00:03:28'),
(4, 'v13_1000027658.mp4', 'http://192.168.47.82/pulmonary//uploads/v13_1000027658.mp4', 'v13', 'v13', '2024-12-16 00:03:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adddoctorvideos`
--
ALTER TABLE `adddoctorvideos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctorlogin`
--
ALTER TABLE `doctorlogin`
  ADD PRIMARY KEY (`doctorId`);

--
-- Indexes for table `doctortable`
--
ALTER TABLE `doctortable`
  ADD PRIMARY KEY (`doctorId`);

--
-- Indexes for table `patientlogin`
--
ALTER TABLE `patientlogin`
  ADD PRIMARY KEY (`PatientId`);

--
-- Indexes for table `screenv1`
--
ALTER TABLE `screenv1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `screenv2`
--
ALTER TABLE `screenv2`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `screenv3`
--
ALTER TABLE `screenv3`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `screenv4`
--
ALTER TABLE `screenv4`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adddoctorvideos`
--
ALTER TABLE `adddoctorvideos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `screenv1`
--
ALTER TABLE `screenv1`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `screenv2`
--
ALTER TABLE `screenv2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `screenv3`
--
ALTER TABLE `screenv3`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `screenv4`
--
ALTER TABLE `screenv4`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
