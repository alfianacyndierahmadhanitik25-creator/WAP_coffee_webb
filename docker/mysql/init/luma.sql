-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 13, 2026 at 02:41 PM
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
-- Database: `luma`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Coffee'),
(2, 'Non-Coffee'),
(3, 'Tea'),
(4, 'Pastry');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `gender` enum('P','L') NOT NULL,
  `address` text DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `user_id`, `gender`, `address`, `date_of_birth`) VALUES
(2, 27, 'L', 'Jakarta Selatan', '2004-03-22'),
(3, 28, 'P', 'Bekasi', '2005-07-10'),
(4, 29, 'L', 'Jakarta Timur', '2004-11-05'),
(5, 30, 'P', 'Bogor', '2005-02-18'),
(6, 31, 'L', 'Depok', '2004-08-27'),
(7, 32, 'P', 'Jakarta Barat', '2005-06-14'),
(8, 33, 'L', 'Tangerang', '2004-09-30'),
(9, 34, 'P', 'Jakarta Selatan', '2005-12-03'),
(10, 35, 'L', 'Depok', '2004-05-19'),
(11, 36, 'P', 'Bekasi', '2005-04-25'),
(12, 37, 'L', 'Jakarta Timur', '2004-10-11'),
(13, 38, 'P', 'Bogor', '2005-08-16'),
(14, 39, 'L', 'Depok', '2004-12-28'),
(15, 40, 'P', 'Jakarta Pusat', '2005-09-07'),
(16, 26, 'P', 'Depok', '2005-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `ingredients`
--

CREATE TABLE `ingredients` (
  `ingredient_id` int(11) NOT NULL,
  `ingredient_name` varchar(100) NOT NULL,
  `unit` varchar(30) NOT NULL,
  `stock` decimal(10,2) NOT NULL DEFAULT 0.00,
  `minimum_stock` decimal(10,2) NOT NULL DEFAULT 0.00,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`ingredient_id`, `ingredient_name`, `unit`, `stock`, `minimum_stock`, `updated_at`) VALUES
(1, 'Coffee Beans', 'kg', 8.00, 3.00, '2026-10-06 08:56:01'),
(2, 'Vanilla Syrup', 'bottle', 10.00, 2.00, '2026-10-06 09:01:29'),
(3, 'Whipped Cream', 'can', 8.00, 2.00, '2026-10-06 09:01:29'),
(4, 'Caramel Sauce', 'bottle', 6.00, 2.00, '2026-10-06 09:01:29'),
(5, 'Ice Cubes', 'kg', 20.00, 5.00, '2026-10-06 09:01:29'),
(6, 'Lemon', 'kg', 5.00, 1.00, '2026-10-06 09:01:29');

--
-- Triggers `ingredients`
--
DELIMITER $$
CREATE TRIGGER `after_ingredient_update` AFTER UPDATE ON `ingredients` FOR EACH ROW BEGIN
    IF OLD.stock <> NEW.stock THEN

        INSERT INTO stock_updates
        (
            ingredient_id,
            update_type,
            quantity,
            old_stock,
            new_stock,
            update_date
        )
        VALUES
        (
            NEW.ingredient_id,

            CASE
                WHEN NEW.stock > OLD.stock THEN 'IN'
                WHEN NEW.stock < OLD.stock THEN 'OUT'
                ELSE 'ADJUSTMENT'
            END,

            ABS(NEW.stock - OLD.stock),

            OLD.stock,
            NEW.stock,
            NOW()
        );

    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `menu_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `menu_name` varchar(100) NOT NULL,
  `price` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` enum('Available','Unavailable') NOT NULL DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`menu_id`, `category_id`, `menu_name`, `price`, `image`, `status`) VALUES
(1, 1, 'Americano', '25000,00', 'americano.jpg', 'Available'),
(2, 1, 'Caramel Matcchiato', '25000,00', 'caramel_matcchiato.jpg', 'Available'),
(3, 1, 'Cappuccino', '28000,00', 'cappuccino.jpg', 'Unavailable'),
(4, 1, 'Mocha Latte', '28000,00', 'mocha_latte.jpg', 'Available'),
(5, 1, 'Affogato', '30000,00', 'Affogato.jpg', 'Available'),
(6, 1, 'Espresso Con Panna', '25000,00', 'espresso_con_panna.jpg', 'Available'),
(7, 1, 'Pumpkin Spice \r\nLatte', '20000,00', 'Pumpkin_Spice_Latte.jpg', 'Unavailable'),
(8, 1, 'Pistachio Latte', '21000,00', 'Pistachio_Latte.jpg', 'Available'),
(9, 1, 'Lavender Latte', '24000,00', 'Lavender_Latte.jpg', 'Available'),
(10, 1, 'Salted Caramel Latte', '28000,00', 'Salted_Caramel_Latte.jpg', 'Available'),
(11, 1, 'Brown Sugar Latte', '27000,00', 'Brown_Sugar_Latte.jpg', 'Available'),
(12, 1, 'Spanish Latte', '22000,00', 'Spanish_Latte.jpg', 'Available'),
(13, 1, 'Java Chip Frappe', '30000,00', 'Java_Chip_Frappe.jpg', 'Available'),
(14, 2, 'Cookies & Cream', '32000,00', 'Cookies&Cream.jpg', 'Available'),
(15, 2, 'Strawberry Matcha', '38000,00', 'Strawberry_Matcha.jpg', 'Available'),
(16, 2, 'Cookies Dough', '34000,00', 'Cookies_Dough.jpg', 'Available'),
(17, 2, 'Matcha Ube', '32000,00', 'Matcha_Ube.jpg', 'Available'),
(18, 2, 'Mint Choco', '30000,00', 'Mint_Choco.jpg', 'Available'),
(19, 2, 'Hazelnut Chocolate', '35000,00', 'Hazelnut_Chocolate.jpg', 'Available'),
(20, 2, 'Matcha Latte', '28000,00', 'Matcha_Latte.jpg', 'Available'),
(21, 2, 'Blue Ocean', '28000,00', 'Blue_Ocean.jpg', 'Unavailable'),
(22, 2, 'Sunset Soda', '35000,00', 'Sunset_Soda.jpg', 'Available'),
(23, 2, 'Mixed Berry \r\nSmoothie', '40000,00', 'Mixed_Berry_Smoothie.jpg', 'Available'),
(24, 2, 'Mixed Pinapple\r\nSmoothie', '32000,00', 'Mixed_Pinapple_Smoothie.jpg', 'Available'),
(25, 2, 'Mixed Dragon Fruit \r\nSmoothie', '32000,00', 'Mixed_Dragon Fruit _Smoothie.jpg', 'Available'),
(26, 3, 'Jasmine Tea', '29000,00', 'Jasmine_Tea.jpg', 'Available'),
(27, 3, 'Oolong Tea', '34000,00', 'Oolong_Tea.jpg', 'Available'),
(28, 3, 'Earl Grey Tea', '28000,00', 'Earl_Grey_Tea.jpg', 'Available'),
(29, 3, 'Rose Tea', '25000,00', 'Rose_Tea.jpg', 'Available'),
(30, 3, 'Peppermint Tea', '30000,00', 'Peppermint_Tea.jpg', 'Available'),
(31, 3, 'Black Tea', '23000,00', 'Black_Tea.jpg', 'Available'),
(32, 3, 'Milk Tea', '30000,00', 'Milk_Tea.jpg', 'Available'),
(33, 3, 'Chamomile Tea', '25000,00', 'Chamomile_Tea.jpg', 'Available'),
(34, 3, 'Lemon Tea', '22000,00', 'Lemon_Tea.jpg', 'Available'),
(35, 3, 'Peach Tea', '24000,00', 'Peach_Tea.jpg', 'Available'),
(36, 3, 'Apple Black Tea', '31000,00', 'Apple_Black_Tea.jpg', 'Available'),
(37, 3, 'Citrus Tea', '26000,00', 'Citrus_Tea.jpg', 'Available'),
(38, 4, 'Cheesecake', '23000,00', 'Cheesecake.jpg', 'Available'),
(39, 4, 'Cinnamon Roll', '28000,00', 'CinnamonRoll.jpg', 'Available'),
(40, 4, 'Croissant', '25000,00', 'Croissant.jpg', 'Available'),
(41, 4, 'Chocolate Cookies', '35000,00', 'Chocolate_Cookies.jpg', 'Available'),
(42, 4, 'Blueberry Muffin', '35000,00', 'Blueberry_Muffin.jpg', 'Available'),
(43, 4, 'Tiramisu Cake', '29000,00', 'Tiramisu_Cake.jpg', 'Available'),
(44, 4, 'Strawberry Danish', '34000,00', 'Strawberry_Danish.jpg', 'Available'),
(45, 4, 'Berries and Cream Croissant', '28000,00', 'BerriesandCreamCroissant.jpg', 'Available'),
(46, 4, 'Eeg Toast', '33000,00', 'Eeg_Toast.jpg', 'Available'),
(47, 4, 'Ham & Cheese Croissaint', '32000,00', 'Ham&Cheese_Croissaint.jpg', 'Available'),
(48, 4, 'Macarons', '28000,00', 'Macarons.jpg', 'Available'),
(49, 4, 'Bagel', '24000,00', 'Bagel.jpg', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `menu_details`
--

CREATE TABLE `menu_details` (
  `menu_detail_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `size` enum('Large','Medium','Small') NOT NULL,
  `price` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_details`
--

INSERT INTO `menu_details` (`menu_detail_id`, `menu_id`, `size`, `price`) VALUES
(1, 1, 'Small', 18000.00),
(2, 1, 'Medium', 25000.00),
(3, 1, 'Large', 30000.00),
(4, 2, 'Small', 22000.00),
(5, 2, 'Medium', 28000.00),
(6, 2, 'Large', 32000.00),
(7, 3, 'Small', 20000.00),
(8, 3, 'Medium', 28000.00),
(9, 3, 'Large', 35000.00),
(10, 4, 'Small', 24000.00),
(11, 4, 'Medium', 28000.00),
(12, 4, 'Large', 33000.00),
(13, 5, 'Small', 25000.00),
(14, 5, 'Medium', 30000.00),
(15, 5, 'Large', 35000.00),
(16, 6, 'Small', 20000.00),
(17, 6, 'Medium', 25000.00),
(18, 6, 'Large', 32000.00),
(19, 7, 'Small', 18000.00),
(20, 7, 'Medium', 20000.00),
(21, 7, 'Large', 24000.00),
(22, 8, 'Small', 19000.00),
(23, 8, 'Medium', 21000.00),
(24, 8, 'Large', 28000.00),
(25, 9, 'Small', 17000.00),
(26, 9, 'Medium', 24000.00),
(27, 9, 'Large', 37000.00),
(28, 10, 'Small', 23000.00),
(29, 10, 'Medium', 28000.00),
(30, 10, 'Large', 30000.00),
(31, 11, 'Small', 20000.00),
(32, 11, 'Medium', 27000.00),
(33, 11, 'Large', 34000.00),
(34, 12, 'Small', 19000.00),
(35, 12, 'Medium', 22000.00),
(36, 12, 'Large', 28000.00),
(37, 13, 'Small', 25000.00),
(38, 13, 'Medium', 30000.00),
(39, 13, 'Large', 37000.00),
(40, 14, 'Small', 28000.00),
(41, 14, 'Medium', 32000.00),
(42, 14, 'Large', 35000.00),
(43, 15, 'Small', 30000.00),
(44, 15, 'Medium', 38000.00),
(45, 15, 'Large', 42000.00),
(46, 16, 'Small', 30000.00),
(47, 16, 'Medium', 34000.00),
(48, 16, 'Large', 42000.00),
(49, 17, 'Small', 27000.00),
(50, 17, 'Medium', 32000.00),
(51, 17, 'Large', 38000.00),
(52, 18, 'Small', 27000.00),
(53, 18, 'Medium', 30000.00),
(54, 18, 'Large', 33000.00),
(55, 19, 'Small', 29000.00),
(56, 19, 'Medium', 35000.00),
(57, 19, 'Large', 38000.00),
(58, 20, 'Small', 25000.00),
(59, 20, 'Medium', 28000.00),
(60, 20, 'Large', 32000.00),
(61, 21, 'Small', 23000.00),
(62, 21, 'Medium', 28000.00),
(63, 21, 'Large', 32000.00),
(64, 22, 'Small', 30000.00),
(65, 22, 'Medium', 35000.00),
(66, 22, 'Large', 42000.00),
(67, 23, 'Small', 36000.00),
(68, 23, 'Medium', 40000.00),
(69, 23, 'Large', 46000.00),
(70, 24, 'Small', 27000.00),
(71, 24, 'Medium', 32000.00),
(72, 24, 'Large', 37000.00),
(73, 25, 'Small', 28000.00),
(74, 25, 'Medium', 32000.00),
(75, 25, 'Large', 38000.00),
(76, 26, 'Small', 25000.00),
(77, 26, 'Medium', 29000.00),
(78, 26, 'Large', 35000.00),
(79, 27, 'Small', 29000.00),
(80, 27, 'Medium', 34000.00),
(81, 27, 'Large', 38000.00),
(82, 28, 'Small', 25000.00),
(83, 28, 'Medium', 28000.00),
(84, 28, 'Large', 32000.00),
(85, 29, 'Small', 20000.00),
(86, 29, 'Medium', 25000.00),
(87, 29, 'Large', 28000.00),
(88, 30, 'Small', 28000.00),
(89, 30, 'Medium', 30000.00),
(90, 30, 'Large', 35000.00),
(91, 31, 'Small', 20000.00),
(92, 31, 'Medium', 23000.00),
(93, 31, 'Large', 25000.00),
(94, 32, 'Small', 25000.00),
(95, 32, 'Medium', 30000.00),
(96, 32, 'Large', 35000.00),
(97, 33, 'Small', 18000.00),
(98, 33, 'Medium', 25000.00),
(99, 33, 'Large', 29000.00),
(100, 34, 'Small', 18000.00),
(101, 34, 'Medium', 22000.00),
(102, 34, 'Large', 25000.00),
(103, 35, 'Small', 20000.00),
(104, 35, 'Medium', 24000.00),
(105, 35, 'Large', 28000.00),
(106, 36, 'Small', 27000.00),
(107, 36, 'Medium', 31000.00),
(108, 36, 'Large', 34000.00),
(109, 37, 'Small', 23000.00),
(110, 37, 'Medium', 26000.00),
(111, 37, 'Large', 30000.00),
(112, 1, 'Small', 18000.00),
(113, 1, 'Medium', 25000.00),
(114, 1, 'Large', 30000.00),
(115, 2, 'Small', 22000.00),
(116, 2, 'Medium', 28000.00),
(117, 2, 'Large', 32000.00),
(118, 3, 'Small', 20000.00),
(119, 3, 'Medium', 28000.00),
(120, 3, 'Large', 35000.00),
(121, 4, 'Small', 24000.00),
(122, 4, 'Medium', 28000.00),
(123, 4, 'Large', 33000.00),
(124, 5, 'Small', 25000.00),
(125, 5, 'Medium', 30000.00),
(126, 5, 'Large', 35000.00),
(127, 6, 'Small', 20000.00),
(128, 6, 'Medium', 25000.00),
(129, 6, 'Large', 32000.00),
(130, 7, 'Small', 18000.00),
(131, 7, 'Medium', 20000.00),
(132, 7, 'Large', 24000.00),
(133, 8, 'Small', 19000.00),
(134, 8, 'Medium', 21000.00),
(135, 8, 'Large', 28000.00),
(136, 9, 'Small', 17000.00),
(137, 9, 'Medium', 24000.00),
(138, 9, 'Large', 37000.00),
(139, 10, 'Small', 23000.00),
(140, 10, 'Medium', 28000.00),
(141, 10, 'Large', 30000.00),
(142, 11, 'Small', 20000.00),
(143, 11, 'Medium', 27000.00),
(144, 11, 'Large', 34000.00),
(145, 12, 'Small', 19000.00),
(146, 12, 'Medium', 22000.00),
(147, 12, 'Large', 28000.00),
(148, 13, 'Small', 25000.00),
(149, 13, 'Medium', 30000.00),
(150, 13, 'Large', 37000.00),
(151, 14, 'Small', 28000.00),
(152, 14, 'Medium', 32000.00),
(153, 14, 'Large', 35000.00),
(154, 15, 'Small', 30000.00),
(155, 15, 'Medium', 38000.00),
(156, 15, 'Large', 42000.00),
(157, 16, 'Small', 30000.00),
(158, 16, 'Medium', 34000.00),
(159, 16, 'Large', 42000.00),
(160, 17, 'Small', 27000.00),
(161, 17, 'Medium', 32000.00),
(162, 17, 'Large', 38000.00),
(163, 18, 'Small', 27000.00),
(164, 18, 'Medium', 30000.00),
(165, 18, 'Large', 33000.00),
(166, 19, 'Small', 29000.00),
(167, 19, 'Medium', 35000.00),
(168, 19, 'Large', 38000.00),
(169, 20, 'Small', 25000.00),
(170, 20, 'Medium', 28000.00),
(171, 20, 'Large', 32000.00),
(172, 21, 'Small', 23000.00),
(173, 21, 'Medium', 28000.00),
(174, 21, 'Large', 32000.00),
(175, 22, 'Small', 30000.00),
(176, 22, 'Medium', 35000.00),
(177, 22, 'Large', 42000.00),
(178, 23, 'Small', 36000.00),
(179, 23, 'Medium', 40000.00),
(180, 23, 'Large', 46000.00),
(181, 24, 'Small', 27000.00),
(182, 24, 'Medium', 32000.00),
(183, 24, 'Large', 37000.00),
(184, 25, 'Small', 28000.00),
(185, 25, 'Medium', 32000.00),
(186, 25, 'Large', 38000.00),
(187, 26, 'Small', 25000.00),
(188, 26, 'Medium', 29000.00),
(189, 26, 'Large', 35000.00),
(190, 27, 'Small', 29000.00),
(191, 27, 'Medium', 34000.00),
(192, 27, 'Large', 38000.00),
(193, 28, 'Small', 25000.00),
(194, 28, 'Medium', 28000.00),
(195, 28, 'Large', 32000.00),
(196, 29, 'Small', 20000.00),
(197, 29, 'Medium', 25000.00),
(198, 29, 'Large', 28000.00),
(199, 30, 'Small', 28000.00),
(200, 30, 'Medium', 30000.00),
(201, 30, 'Large', 35000.00),
(202, 31, 'Small', 20000.00),
(203, 31, 'Medium', 23000.00),
(204, 31, 'Large', 25000.00),
(205, 32, 'Small', 25000.00),
(206, 32, 'Medium', 30000.00),
(207, 32, 'Large', 35000.00),
(208, 33, 'Small', 18000.00),
(209, 33, 'Medium', 25000.00),
(210, 33, 'Large', 29000.00),
(211, 34, 'Small', 18000.00),
(212, 34, 'Medium', 22000.00),
(213, 34, 'Large', 25000.00),
(214, 35, 'Small', 20000.00),
(215, 35, 'Medium', 24000.00),
(216, 35, 'Large', 28000.00),
(217, 36, 'Small', 27000.00),
(218, 36, 'Medium', 31000.00),
(219, 36, 'Large', 34000.00),
(220, 37, 'Small', 23000.00),
(221, 37, 'Medium', 26000.00),
(222, 37, 'Large', 30000.00),
(223, 1, 'Small', 18000.00),
(224, 1, 'Medium', 25000.00),
(225, 1, 'Large', 30000.00),
(226, 2, 'Small', 22000.00),
(227, 2, 'Medium', 28000.00),
(228, 2, 'Large', 32000.00),
(229, 3, 'Small', 20000.00),
(230, 3, 'Medium', 28000.00),
(231, 3, 'Large', 35000.00),
(232, 4, 'Small', 24000.00),
(233, 4, 'Medium', 28000.00),
(234, 4, 'Large', 33000.00),
(235, 5, 'Small', 25000.00),
(236, 5, 'Medium', 30000.00),
(237, 5, 'Large', 35000.00),
(238, 6, 'Small', 20000.00),
(239, 6, 'Medium', 25000.00),
(240, 6, 'Large', 32000.00),
(241, 7, 'Small', 18000.00),
(242, 7, 'Medium', 20000.00),
(243, 7, 'Large', 24000.00),
(244, 8, 'Small', 19000.00),
(245, 8, 'Medium', 21000.00),
(246, 8, 'Large', 28000.00),
(247, 9, 'Small', 17000.00),
(248, 9, 'Medium', 24000.00),
(249, 9, 'Large', 37000.00),
(250, 10, 'Small', 23000.00),
(251, 10, 'Medium', 28000.00),
(252, 10, 'Large', 30000.00),
(253, 11, 'Small', 20000.00),
(254, 11, 'Medium', 27000.00),
(255, 11, 'Large', 34000.00),
(256, 12, 'Small', 19000.00),
(257, 12, 'Medium', 22000.00),
(258, 12, 'Large', 28000.00),
(259, 13, 'Small', 25000.00),
(260, 13, 'Medium', 30000.00),
(261, 13, 'Large', 37000.00),
(262, 14, 'Small', 28000.00),
(263, 14, 'Medium', 32000.00),
(264, 14, 'Large', 35000.00),
(265, 15, 'Small', 30000.00),
(266, 15, 'Medium', 38000.00),
(267, 15, 'Large', 42000.00),
(268, 16, 'Small', 30000.00),
(269, 16, 'Medium', 34000.00),
(270, 16, 'Large', 42000.00),
(271, 17, 'Small', 27000.00),
(272, 17, 'Medium', 32000.00),
(273, 17, 'Large', 38000.00),
(274, 18, 'Small', 27000.00),
(275, 18, 'Medium', 30000.00),
(276, 18, 'Large', 33000.00),
(277, 19, 'Small', 29000.00),
(278, 19, 'Medium', 35000.00),
(279, 19, 'Large', 38000.00),
(280, 20, 'Small', 25000.00),
(281, 20, 'Medium', 28000.00),
(282, 20, 'Large', 32000.00),
(283, 21, 'Small', 23000.00),
(284, 21, 'Medium', 28000.00),
(285, 21, 'Large', 32000.00),
(286, 22, 'Small', 30000.00),
(287, 22, 'Medium', 35000.00),
(288, 22, 'Large', 42000.00),
(289, 23, 'Small', 36000.00),
(290, 23, 'Medium', 40000.00),
(291, 23, 'Large', 46000.00),
(292, 24, 'Small', 27000.00),
(293, 24, 'Medium', 32000.00),
(294, 24, 'Large', 37000.00),
(295, 25, 'Small', 28000.00),
(296, 25, 'Medium', 32000.00),
(297, 25, 'Large', 38000.00),
(298, 26, 'Small', 25000.00),
(299, 26, 'Medium', 29000.00),
(300, 26, 'Large', 35000.00),
(301, 27, 'Small', 29000.00),
(302, 27, 'Medium', 34000.00),
(303, 27, 'Large', 38000.00),
(304, 28, 'Small', 25000.00),
(305, 28, 'Medium', 28000.00),
(306, 28, 'Large', 32000.00),
(307, 29, 'Small', 20000.00),
(308, 29, 'Medium', 25000.00),
(309, 29, 'Large', 28000.00),
(310, 30, 'Small', 28000.00),
(311, 30, 'Medium', 30000.00),
(312, 30, 'Large', 35000.00),
(313, 31, 'Small', 20000.00),
(314, 31, 'Medium', 23000.00),
(315, 31, 'Large', 25000.00),
(316, 32, 'Small', 25000.00),
(317, 32, 'Medium', 30000.00),
(318, 32, 'Large', 35000.00),
(319, 33, 'Small', 18000.00),
(320, 33, 'Medium', 25000.00),
(321, 33, 'Large', 29000.00),
(322, 34, 'Small', 18000.00),
(323, 34, 'Medium', 22000.00),
(324, 34, 'Large', 25000.00),
(325, 35, 'Small', 20000.00),
(326, 35, 'Medium', 24000.00),
(327, 35, 'Large', 28000.00),
(328, 36, 'Small', 27000.00),
(329, 36, 'Medium', 31000.00),
(330, 36, 'Large', 34000.00),
(331, 37, 'Small', 23000.00),
(332, 37, 'Medium', 26000.00),
(333, 37, 'Large', 30000.00),
(334, 1, 'Small', 18000.00),
(335, 1, 'Medium', 25000.00),
(336, 1, 'Large', 30000.00),
(337, 2, 'Small', 22000.00),
(338, 2, 'Medium', 28000.00),
(339, 2, 'Large', 32000.00),
(340, 3, 'Small', 20000.00),
(341, 3, 'Medium', 28000.00),
(342, 3, 'Large', 35000.00),
(343, 4, 'Small', 24000.00),
(344, 4, 'Medium', 28000.00),
(345, 4, 'Large', 33000.00),
(346, 5, 'Small', 25000.00),
(347, 5, 'Medium', 30000.00),
(348, 5, 'Large', 35000.00),
(349, 6, 'Small', 20000.00),
(350, 6, 'Medium', 25000.00),
(351, 6, 'Large', 32000.00),
(352, 7, 'Small', 18000.00),
(353, 7, 'Medium', 20000.00),
(354, 7, 'Large', 24000.00),
(355, 8, 'Small', 19000.00),
(356, 8, 'Medium', 21000.00),
(357, 8, 'Large', 28000.00),
(358, 9, 'Small', 17000.00),
(359, 9, 'Medium', 24000.00),
(360, 9, 'Large', 37000.00),
(361, 10, 'Small', 23000.00),
(362, 10, 'Medium', 28000.00),
(363, 10, 'Large', 30000.00),
(364, 11, 'Small', 20000.00),
(365, 11, 'Medium', 27000.00),
(366, 11, 'Large', 34000.00),
(367, 12, 'Small', 19000.00),
(368, 12, 'Medium', 22000.00),
(369, 12, 'Large', 28000.00),
(370, 13, 'Small', 25000.00),
(371, 13, 'Medium', 30000.00),
(372, 13, 'Large', 37000.00),
(373, 14, 'Small', 28000.00),
(374, 14, 'Medium', 32000.00),
(375, 14, 'Large', 35000.00),
(376, 15, 'Small', 30000.00),
(377, 15, 'Medium', 38000.00),
(378, 15, 'Large', 42000.00),
(379, 16, 'Small', 30000.00),
(380, 16, 'Medium', 34000.00),
(381, 16, 'Large', 42000.00),
(382, 17, 'Small', 27000.00),
(383, 17, 'Medium', 32000.00),
(384, 17, 'Large', 38000.00),
(385, 18, 'Small', 27000.00),
(386, 18, 'Medium', 30000.00),
(387, 18, 'Large', 33000.00),
(388, 19, 'Small', 29000.00),
(389, 19, 'Medium', 35000.00),
(390, 19, 'Large', 38000.00),
(391, 20, 'Small', 25000.00),
(392, 20, 'Medium', 28000.00),
(393, 20, 'Large', 32000.00),
(394, 21, 'Small', 23000.00),
(395, 21, 'Medium', 28000.00),
(396, 21, 'Large', 32000.00),
(397, 22, 'Small', 30000.00),
(398, 22, 'Medium', 35000.00),
(399, 22, 'Large', 42000.00),
(400, 23, 'Small', 36000.00),
(401, 23, 'Medium', 40000.00),
(402, 23, 'Large', 46000.00),
(403, 24, 'Small', 27000.00),
(404, 24, 'Medium', 32000.00),
(405, 24, 'Large', 37000.00),
(406, 25, 'Small', 28000.00),
(407, 25, 'Medium', 32000.00),
(408, 25, 'Large', 38000.00),
(409, 26, 'Small', 25000.00),
(410, 26, 'Medium', 29000.00),
(411, 26, 'Large', 35000.00),
(412, 27, 'Small', 29000.00),
(413, 27, 'Medium', 34000.00),
(414, 27, 'Large', 38000.00),
(415, 28, 'Small', 25000.00),
(416, 28, 'Medium', 28000.00),
(417, 28, 'Large', 32000.00),
(418, 29, 'Small', 20000.00),
(419, 29, 'Medium', 25000.00),
(420, 29, 'Large', 28000.00),
(421, 30, 'Small', 28000.00),
(422, 30, 'Medium', 30000.00),
(423, 30, 'Large', 35000.00),
(424, 31, 'Small', 20000.00),
(425, 31, 'Medium', 23000.00),
(426, 31, 'Large', 25000.00),
(427, 32, 'Small', 25000.00),
(428, 32, 'Medium', 30000.00),
(429, 32, 'Large', 35000.00),
(430, 33, 'Small', 18000.00),
(431, 33, 'Medium', 25000.00),
(432, 33, 'Large', 29000.00),
(433, 34, 'Small', 18000.00),
(434, 34, 'Medium', 22000.00),
(435, 34, 'Large', 25000.00),
(436, 35, 'Small', 20000.00),
(437, 35, 'Medium', 24000.00),
(438, 35, 'Large', 28000.00),
(439, 36, 'Small', 27000.00),
(440, 36, 'Medium', 31000.00),
(441, 36, 'Large', 34000.00),
(442, 37, 'Small', 23000.00),
(443, 37, 'Medium', 26000.00),
(444, 37, 'Large', 30000.00),
(445, 1, 'Small', 18000.00),
(446, 1, 'Medium', 25000.00),
(447, 1, 'Large', 30000.00),
(448, 2, 'Small', 22000.00),
(449, 2, 'Medium', 28000.00),
(450, 2, 'Large', 32000.00),
(451, 3, 'Small', 20000.00),
(452, 3, 'Medium', 28000.00),
(453, 3, 'Large', 35000.00),
(454, 4, 'Small', 24000.00),
(455, 4, 'Medium', 28000.00),
(456, 4, 'Large', 33000.00),
(457, 5, 'Small', 25000.00),
(458, 5, 'Medium', 30000.00),
(459, 5, 'Large', 35000.00),
(460, 6, 'Small', 20000.00),
(461, 6, 'Medium', 25000.00),
(462, 6, 'Large', 32000.00),
(463, 7, 'Small', 18000.00),
(464, 7, 'Medium', 20000.00),
(465, 7, 'Large', 24000.00),
(466, 8, 'Small', 19000.00),
(467, 8, 'Medium', 21000.00),
(468, 8, 'Large', 28000.00),
(469, 9, 'Small', 17000.00),
(470, 9, 'Medium', 24000.00),
(471, 9, 'Large', 37000.00),
(472, 10, 'Small', 23000.00),
(473, 10, 'Medium', 28000.00),
(474, 10, 'Large', 30000.00),
(475, 11, 'Small', 20000.00),
(476, 11, 'Medium', 27000.00),
(477, 11, 'Large', 34000.00),
(478, 12, 'Small', 19000.00),
(479, 12, 'Medium', 22000.00),
(480, 12, 'Large', 28000.00),
(481, 13, 'Small', 25000.00),
(482, 13, 'Medium', 30000.00),
(483, 13, 'Large', 37000.00),
(484, 14, 'Small', 28000.00),
(485, 14, 'Medium', 32000.00),
(486, 14, 'Large', 35000.00),
(487, 15, 'Small', 30000.00),
(488, 15, 'Medium', 38000.00),
(489, 15, 'Large', 42000.00),
(490, 16, 'Small', 30000.00),
(491, 16, 'Medium', 34000.00),
(492, 16, 'Large', 42000.00),
(493, 17, 'Small', 27000.00),
(494, 17, 'Medium', 32000.00),
(495, 17, 'Large', 38000.00),
(496, 18, 'Small', 27000.00),
(497, 18, 'Medium', 30000.00),
(498, 18, 'Large', 33000.00),
(499, 19, 'Small', 29000.00),
(500, 19, 'Medium', 35000.00),
(501, 19, 'Large', 38000.00),
(502, 20, 'Small', 25000.00),
(503, 20, 'Medium', 28000.00),
(504, 20, 'Large', 32000.00),
(505, 21, 'Small', 23000.00),
(506, 21, 'Medium', 28000.00),
(507, 21, 'Large', 32000.00),
(508, 22, 'Small', 30000.00),
(509, 22, 'Medium', 35000.00),
(510, 22, 'Large', 42000.00),
(511, 23, 'Small', 36000.00),
(512, 23, 'Medium', 40000.00),
(513, 23, 'Large', 46000.00),
(514, 24, 'Small', 27000.00),
(515, 24, 'Medium', 32000.00),
(516, 24, 'Large', 37000.00),
(517, 25, 'Small', 28000.00),
(518, 25, 'Medium', 32000.00),
(519, 25, 'Large', 38000.00),
(520, 26, 'Small', 25000.00),
(521, 26, 'Medium', 29000.00),
(522, 26, 'Large', 35000.00),
(523, 27, 'Small', 29000.00),
(524, 27, 'Medium', 34000.00),
(525, 27, 'Large', 38000.00),
(526, 28, 'Small', 25000.00),
(527, 28, 'Medium', 28000.00),
(528, 28, 'Large', 32000.00),
(529, 29, 'Small', 20000.00),
(530, 29, 'Medium', 25000.00),
(531, 29, 'Large', 28000.00),
(532, 30, 'Small', 28000.00),
(533, 30, 'Medium', 30000.00),
(534, 30, 'Large', 35000.00),
(535, 31, 'Small', 20000.00),
(536, 31, 'Medium', 23000.00),
(537, 31, 'Large', 25000.00),
(538, 32, 'Small', 25000.00),
(539, 32, 'Medium', 30000.00),
(540, 32, 'Large', 35000.00),
(541, 33, 'Small', 18000.00),
(542, 33, 'Medium', 25000.00),
(543, 33, 'Large', 29000.00),
(544, 34, 'Small', 18000.00),
(545, 34, 'Medium', 22000.00),
(546, 34, 'Large', 25000.00),
(547, 35, 'Small', 20000.00),
(548, 35, 'Medium', 24000.00),
(549, 35, 'Large', 28000.00),
(550, 36, 'Small', 27000.00),
(551, 36, 'Medium', 31000.00),
(552, 36, 'Large', 34000.00),
(553, 37, 'Small', 23000.00),
(554, 37, 'Medium', 26000.00),
(555, 37, 'Large', 30000.00);

-- --------------------------------------------------------

--
-- Table structure for table `moments`
--

CREATE TABLE `moments` (
  `moment_id` int(11) NOT NULL,
  `moment_name` varchar(100) NOT NULL,
  `icon` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `moments`
--

INSERT INTO `moments` (`moment_id`, `moment_name`, `icon`) VALUES
(5, 'Study Time', '📚'),
(6, 'Work Mode', '💻'),
(7, 'Need a Break', '🌿'),
(8, 'Refreshment', '☕');

-- --------------------------------------------------------

--
-- Table structure for table `moment_recommendation`
--

CREATE TABLE `moment_recommendation` (
  `recommendation_id` int(11) NOT NULL,
  `moment_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `moment_recommendation`
--

INSERT INTO `moment_recommendation` (`recommendation_id`, `moment_id`, `menu_id`) VALUES
(1, 5, 15),
(2, 5, 20),
(3, 5, 18),
(4, 5, 1),
(5, 5, 2),
(6, 5, 4),
(7, 5, 32),
(8, 5, 27),
(9, 5, 28),
(10, 5, 43),
(11, 5, 41),
(12, 5, 38),
(13, 6, 14),
(14, 6, 18),
(15, 6, 19),
(16, 6, 1),
(17, 6, 2),
(18, 6, 4),
(19, 6, 31),
(20, 6, 30),
(21, 6, 26),
(22, 6, 43),
(23, 6, 38),
(24, 6, 40),
(25, 7, 15),
(26, 7, 19),
(27, 7, 16),
(28, 7, 9),
(29, 7, 7),
(30, 7, 5),
(31, 7, 27),
(32, 7, 28),
(33, 7, 31),
(34, 7, 42),
(35, 7, 39),
(36, 7, 40),
(37, 8, 20),
(38, 8, 17),
(39, 8, 16),
(40, 8, 8),
(41, 8, 5),
(42, 8, 7),
(43, 8, 32),
(44, 8, 26),
(45, 8, 31),
(46, 8, 38),
(47, 8, 40),
(48, 8, 39);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('Success','Failed') NOT NULL,
  `order_status` enum('Pending','Processing','Completed') NOT NULL DEFAULT 'Pending',
  `order_type` enum('Dine In','Take Away') NOT NULL DEFAULT 'Take Away',
  `payment_method` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `total_amount`, `status`, `order_status`, `order_type`, `payment_method`) VALUES
(1, 26, '2026-09-10 08:30:00', 50000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(2, 26, '2026-09-18 09:15:00', 56000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(3, 27, '2026-09-10 09:15:00', 28000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(4, 28, '2026-09-10 10:20:00', 41000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(5, 28, '2026-09-20 13:10:00', 48000.00, 'Failed', 'Pending', 'Take Away', 'QRIS'),
(6, 29, '2026-09-11 11:05:00', 60000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(7, 30, '2026-09-11 12:30:00', 24000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(8, 30, '2026-09-21 15:20:00', 50000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(9, 31, '2026-09-11 14:10:00', 36000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(10, 32, '2026-09-12 08:45:00', 36000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(11, 32, '2026-09-22 10:30:00', 60000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(12, 33, '2026-09-12 10:30:00', 32000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(13, 34, '2026-09-12 13:20:00', 40000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(14, 34, '2026-09-23 14:15:00', 54000.00, 'Failed', 'Pending', 'Take Away', 'QRIS'),
(15, 35, '2026-09-13 15:00:00', 30000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(16, 36, '2026-09-13 16:15:00', 50000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(17, 36, '2026-09-24 09:40:00', 28000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(18, 37, '2026-09-14 09:40:00', 28000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(19, 38, '2026-09-14 12:10:00', 48000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(20, 39, '2026-09-15 14:30:00', 60000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(21, 39, '2026-09-25 16:20:00', 50000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(22, 40, '2026-09-15 18:20:00', 25000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(23, 26, '2026-09-10 08:30:00', 50000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(24, 26, '2026-09-18 09:15:00', 56000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(25, 27, '2026-09-10 09:15:00', 28000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(26, 28, '2026-09-10 10:20:00', 41000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(27, 28, '2026-09-20 13:10:00', 48000.00, 'Failed', 'Pending', 'Take Away', 'QRIS'),
(28, 29, '2026-09-11 11:05:00', 60000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(29, 30, '2026-09-11 12:30:00', 24000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(30, 30, '2026-09-21 15:20:00', 50000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(31, 31, '2026-09-11 14:10:00', 36000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(32, 32, '2026-09-12 08:45:00', 36000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(33, 32, '2026-09-22 10:30:00', 60000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(34, 33, '2026-09-12 10:30:00', 32000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(35, 34, '2026-09-12 13:20:00', 40000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(36, 34, '2026-09-23 14:15:00', 54000.00, 'Failed', 'Pending', 'Take Away', 'QRIS'),
(37, 35, '2026-09-13 15:00:00', 30000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(38, 36, '2026-09-13 16:15:00', 50000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(39, 36, '2026-09-24 09:40:00', 28000.00, 'Failed', 'Pending', 'Take Away', 'Cash'),
(40, 37, '2026-09-14 09:40:00', 28000.00, 'Success', 'Pending', 'Take Away', 'Cash'),
(41, 38, '2026-09-14 12:10:00', 48000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(42, 39, '2026-09-15 14:30:00', 60000.00, 'Success', 'Pending', 'Take Away', 'Debit'),
(43, 39, '2026-09-25 16:20:00', 50000.00, 'Success', 'Pending', 'Take Away', 'QRIS'),
(44, 40, '2026-09-15 18:20:00', 25000.00, 'Failed', 'Pending', 'Take Away', 'Cash');

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `order_detail_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`order_detail_id`, `order_id`, `menu_id`, `quantity`, `price`, `subtotal`) VALUES
(40, 1, 1, 1, 25000.00, 25000.00),
(41, 1, 2, 1, 25000.00, 25000.00),
(42, 2, 3, 1, 28000.00, 28000.00),
(43, 2, 4, 1, 28000.00, 28000.00),
(44, 3, 5, 1, 30000.00, 14000.00),
(45, 3, 6, 1, 32000.00, 14000.00),
(46, 4, 7, 1, 20000.00, 20000.00),
(47, 4, 8, 1, 21000.00, 21000.00),
(48, 5, 9, 1, 24000.00, 24000.00),
(49, 5, 1, 1, 24000.00, 24000.00),
(50, 6, 2, 1, 30000.00, 30000.00),
(51, 6, 3, 1, 30000.00, 30000.00),
(52, 7, 4, 1, 12000.00, 12000.00),
(53, 7, 5, 1, 12000.00, 12000.00),
(54, 8, 6, 1, 25000.00, 25000.00),
(55, 8, 7, 1, 25000.00, 25000.00),
(56, 9, 8, 1, 18000.00, 18000.00),
(57, 9, 9, 1, 18000.00, 18000.00),
(58, 10, 1, 1, 18000.00, 18000.00),
(59, 10, 2, 1, 18000.00, 18000.00),
(60, 11, 3, 1, 30000.00, 30000.00),
(61, 11, 4, 1, 30000.00, 30000.00),
(62, 12, 5, 1, 16000.00, 16000.00),
(63, 12, 6, 1, 16000.00, 16000.00),
(64, 13, 7, 1, 20000.00, 20000.00),
(65, 13, 8, 1, 20000.00, 20000.00),
(66, 14, 9, 1, 27000.00, 27000.00),
(67, 14, 1, 1, 27000.00, 27000.00),
(68, 15, 2, 1, 15000.00, 15000.00),
(69, 15, 3, 1, 15000.00, 15000.00),
(70, 16, 4, 1, 25000.00, 25000.00),
(71, 16, 5, 1, 25000.00, 25000.00),
(72, 17, 6, 1, 14000.00, 14000.00),
(73, 17, 7, 1, 14000.00, 14000.00),
(74, 18, 8, 1, 14000.00, 14000.00),
(75, 18, 9, 1, 14000.00, 14000.00),
(76, 19, 1, 1, 24000.00, 24000.00),
(77, 19, 2, 1, 24000.00, 24000.00);

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

CREATE TABLE `rewards` (
  `reward_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `level` varchar(50) NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rewards`
--

INSERT INTO `rewards` (`reward_id`, `user_id`, `points`, `level`, `updated_at`) VALUES
(1, 26, 120, 'Bronze', '2026-09-10 09:00:00'),
(2, 27, 250, 'Silver', '2026-09-10 10:00:00'),
(3, 28, 80, 'Bronze', '2026-09-10 11:00:00'),
(4, 29, 450, 'Silver', '2026-09-11 12:00:00'),
(5, 30, 600, 'Gold', '2026-09-11 13:00:00'),
(6, 31, 150, 'Bronze', '2026-09-11 15:00:00'),
(7, 32, 320, 'Silver', '2026-09-12 09:00:00'),
(8, 33, 720, 'Gold', '2026-09-12 11:00:00'),
(9, 34, 90, 'Bronze', '2026-09-12 14:00:00'),
(10, 35, 500, 'Gold', '2026-09-13 16:00:00'),
(11, 36, 210, 'Silver', '2026-09-13 17:00:00'),
(12, 37, 60, 'Bronze', '2026-09-14 10:00:00'),
(13, 38, 850, 'Gold', '2026-09-14 13:00:00'),
(14, 39, 180, 'Bronze', '2026-09-15 15:00:00'),
(15, 40, 300, 'Silver', '2026-09-15 19:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `position` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_id`, `user_id`, `position`, `role`) VALUES
(16, 16, 'Manager', 'Admin'),
(17, 17, 'Cashier', 'Staff'),
(18, 18, 'Barista', 'Staff'),
(19, 19, 'Barista', 'Staff'),
(20, 20, 'Cashier', 'Staff'),
(21, 21, 'Barista', 'Staff'),
(22, 22, 'Supervisor', 'Staff'),
(23, 23, 'Cashier', 'Staff'),
(24, 24, 'Barista', 'Staff'),
(25, 25, 'Barista', 'Staff');

-- --------------------------------------------------------

--
-- Table structure for table `stock_updates`
--

CREATE TABLE `stock_updates` (
  `stock_update_id` int(11) NOT NULL,
  `ingredient_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `update_type` enum('IN','OUT','ADJUSTMENT') NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `old_stock` decimal(10,2) DEFAULT NULL,
  `new_stock` decimal(10,2) DEFAULT NULL,
  `update_date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_updates`
--

INSERT INTO `stock_updates` (`stock_update_id`, `ingredient_id`, `staff_id`, `update_type`, `quantity`, `old_stock`, `new_stock`, `update_date`, `notes`) VALUES
(1, 1, 18, 'OUT', 2.00, 10.00, 8.00, '2026-10-06 08:56:01', NULL),
(7, 2, 18, 'IN', 5.00, 10.00, 15.00, '2026-10-06 09:00:00', 'New vanilla syrup stock'),
(8, 3, 19, 'IN', 4.00, 8.00, 12.00, '2026-10-06 09:15:00', 'Whipped cream restock'),
(9, 4, 21, 'OUT', 2.00, 6.00, 4.00, '2026-10-06 09:30:00', 'Used for caramel latte'),
(10, 5, 24, 'OUT', 5.00, 20.00, 15.00, '2026-10-06 10:00:00', 'Used for beverage preparation'),
(11, 6, 25, 'IN', 3.00, 5.00, 8.00, '2026-10-06 10:30:00', 'New lemon stock');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `phone`, `created_at`) VALUES
(16, 'Alya Putri', 'alya.putri@gmail.com', 'ayla990', '081234567801', '2026-09-01 08:15:00'),
(17, 'Raka Pratama', 'raka.pratama@gmail.com', 'nasigoreng00', '081234567802', '2026-09-01 09:20:00'),
(18, 'Nadia Safitri', 'nadia.safitri@gmail.com', 'dolarpernah18k', '081234567803', '2026-09-02 10:05:00'),
(19, 'Fajar Ramadhan', 'fajar.ramadhan@gmail.com', 'asoygeboy88', '081234567804', '2026-09-02 11:30:00'),
(20, 'Citra Lestari', 'citra.lestari@gmail.com', 'nasgorampela', '081234567805', '2026-09-03 13:10:00'),
(21, 'Dimas Saputra', 'dimas.saputra@gmail.com', 'bissmillahaaman', '081234567806', '2026-09-03 14:25:00'),
(22, 'Salsa Maharani', 'salsa.maharani@gmail.com', 'aminaminn123', '081234567807', '2026-09-04 08:45:00'),
(23, 'Rizky Maulana', 'rizky.maulana@gmail.com', 'rxky89', '081234567808', '2026-09-04 10:15:00'),
(24, 'Anisa Rahma', 'anisa.rahma@gmail.com', 'ansR3', '081234567809', '2026-09-05 12:40:00'),
(25, 'Kevin Wijaya', 'kevin.wijaya@gmail.com', 'kevin00', '081234567810', '2026-09-05 15:20:00'),
(26, 'Nabila Azzahra', 'nabila.azzahra@gmail.com', 'nabloe3', '081234567811', '2026-09-06 09:10:00'),
(27, 'Bagas Firmansyah', 'bagas.firmansyah@gmail.com', 'bgsfrmn90', '081234567812', '2026-09-06 11:50:00'),
(28, 'Tiara Anindya', 'tiara.anindya@gmail.com', 'tiatianin974', '081234567813', '2026-09-07 13:35:00'),
(29, 'Ardi Nugraha', 'ardi.nugraha@gmail.com', 'nasgorgoreng23', '081234567814', '2026-09-07 16:05:00'),
(30, 'Maya Salsabila', 'maya.salsabila@gmail.com', 'password123', '081234567815', '2026-09-08 10:30:00'),
(31, 'Alya Putri', 'alya.putri@gmail.com', 'Alya@123', '081234567801', '2026-09-01 08:15:00'),
(32, 'Raka Pratama', 'raka.pratama@gmail.com', 'Raka#456', '081234567802', '2026-09-01 09:20:00'),
(33, 'Nadia Safitri', 'nadia.safitri@gmail.com', 'Nadia789!', '081234567803', '2026-09-02 10:05:00'),
(34, 'Fajar Ramadhan', 'fajar.ramadhan@gmail.com', 'Fajar@2026', '081234567804', '2026-09-02 11:30:00'),
(35, 'Citra Lestari', 'citra.lestari@gmail.com', 'Citra#321', '081234567805', '2026-09-03 13:10:00'),
(36, 'Dimas Saputra', 'dimas.saputra@gmail.com', 'Dimas@789', '081234567806', '2026-09-03 14:25:00'),
(37, 'Salsa Maharani', 'salsa.maharani@gmail.com', 'Salsa!456', '081234567807', '2026-09-04 08:45:00'),
(38, 'Rizky Maulana', 'rizky.maulana@gmail.com', 'Rizky@321', '081234567808', '2026-09-04 10:15:00'),
(39, 'Anisa Rahma', 'anisa.rahma@gmail.com', 'Anisa#987', '081234567809', '2026-09-05 12:40:00'),
(40, 'Kevin Wijaya', 'kevin.wijaya@gmail.com', 'Kevin@654', '081234567810', '2026-09-05 15:20:00'),
(41, 'Nabila Azzahra', 'nabila.azzahra@gmail.com', 'Nabila!234', '081234567811', '2026-09-06 09:10:00'),
(42, 'Bagas Firmansyah', 'bagas.firmansyah@gmail.com', 'Bagas#876', '081234567812', '2026-09-06 11:50:00'),
(43, 'Tiara Anindya', 'tiara.anindya@gmail.com', 'Tiara@543', '081234567813', '2026-09-07 13:35:00'),
(44, 'Ardi Nugraha', 'ardi.nugraha@gmail.com', 'Ardi!210', '081234567814', '2026-09-07 16:05:00'),
(45, 'Maya Salsabila', 'maya.salsabila@gmail.com', 'Maya#765', '081234567815', '2026-09-08 10:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `fk_customer_user` (`user_id`);

--
-- Indexes for table `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`ingredient_id`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `fk_menu_category` (`category_id`);

--
-- Indexes for table `menu_details`
--
ALTER TABLE `menu_details`
  ADD PRIMARY KEY (`menu_detail_id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indexes for table `moments`
--
ALTER TABLE `moments`
  ADD PRIMARY KEY (`moment_id`);

--
-- Indexes for table `moment_recommendation`
--
ALTER TABLE `moment_recommendation`
  ADD PRIMARY KEY (`recommendation_id`),
  ADD KEY `moment_id` (`moment_id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indexes for table `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`reward_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`),
  ADD KEY `fk_staff_user` (`user_id`);

--
-- Indexes for table `stock_updates`
--
ALTER TABLE `stock_updates`
  ADD PRIMARY KEY (`stock_update_id`),
  ADD KEY `ingredient_id` (`ingredient_id`),
  ADD KEY `staff_id` (`staff_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `ingredient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `menu_details`
--
ALTER TABLE `menu_details`
  MODIFY `menu_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=556;

--
-- AUTO_INCREMENT for table `moments`
--
ALTER TABLE `moments`
  MODIFY `moment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `moment_recommendation`
--
ALTER TABLE `moment_recommendation`
  MODIFY `recommendation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `order_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `rewards`
--
ALTER TABLE `rewards`
  MODIFY `reward_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `stock_updates`
--
ALTER TABLE `stock_updates`
  MODIFY `stock_update_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `fk_customer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `menus`
--
ALTER TABLE `menus`
  ADD CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `menu_details`
--
ALTER TABLE `menu_details`
  ADD CONSTRAINT `menu_details_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`menu_id`);

--
-- Constraints for table `moment_recommendation`
--
ALTER TABLE `moment_recommendation`
  ADD CONSTRAINT `moment_recommendation_ibfk_1` FOREIGN KEY (`moment_id`) REFERENCES `moments` (`moment_id`),
  ADD CONSTRAINT `moment_recommendation_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`menu_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`menu_id`);

--
-- Constraints for table `rewards`
--
ALTER TABLE `rewards`
  ADD CONSTRAINT `rewards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `fk_staff_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `stock_updates`
--
ALTER TABLE `stock_updates`
  ADD CONSTRAINT `stock_updates_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`ingredient_id`),
  ADD CONSTRAINT `stock_updates_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
