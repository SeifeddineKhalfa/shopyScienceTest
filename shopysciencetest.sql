-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 22 mars 2023 à 17:59
-- Version du serveur : 8.0.31
-- Version de PHP : 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `shopyscience`
--

-- --------------------------------------------------------

--
-- Structure de la table `contact`
--

DROP TABLE IF EXISTS `contact`;
CREATE TABLE IF NOT EXISTS `contact` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_line2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `contact`
--

INSERT INTO `contact` (`id`, `account_name`, `address_line1`, `address_line2`, `city`, `contact_name`, `country`, `zip_code`) VALUES
('99e06a8d-997c-4251-8cb7-27dab335ca1b', 'Naâma', '2 Rue du 2 Mars 1934', NULL, 'Tunis', 'Halima Ben Hassen', 'TN', '1000'),
('bf74b017-740b-4e34-8294-0df4fc1dee7e', 'Francis Cabrel', '3 rue de la chanson', NULL, 'Astaffort', 'Francis Cabrel', 'FR', '47000');

-- --------------------------------------------------------

--
-- Structure de la table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE IF NOT EXISTS `item` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `item`
--

INSERT INTO `item` (`id`, `description`) VALUES
('01c51e89-68e5-4ba4-a3b7-c76bf95ab92b', 'GREEN FLASH - Peach 15ML'),
('0d9cf810-fdd1-4b26-8ad2-c4c1f0c001f7', 'PUB -  Planche Stickers parfumes crememains'),
('2470414f-772b-4217-9906-7750c63351e9', 'GREEN FLASH - Milky White 15ML'),
('3c393465-981e-4e85-b07e-13af762056c5', 'GREEN FLASH - Gold sand 15ML'),
('40222201-93d1-4f2d-a56c-49bc060ad114', 'GREEN FLASH - Navy Blue 15ML'),
('62cf18c2-89ab-4bf1-ab34-4e598c17b7f4', 'GREEN FLASH - Dark pansy 15ML'),
('64db5397-a0d2-4b28-b824-ff39a72ad341', 'GREEN FLASH - Light Blue 15ML'),
('6905f992-6e55-489c-a369-4a5750c42177', 'ACC - PINCES DE DEPOSE X5'),
('6c5b5c6e-1e78-41aa-a017-5127094625aa', 'GREEN FLASH - Coffret de Noel 24W - pre rempli'),
('82706172-4413-4ef9-937c-fa4eca30e21f', 'GREEN FLASH - Peonie 15ML'),
('8f6bc422-a0b1-4975-9782-502babbbaa86', 'GREEN FLASH - Khaki 15ML'),
('978b685f-f059-432f-929d-e3e62db98217', 'FRAIS DE TRANSPORT'),
('b81e7448-8a45-4ff5-ba3a-0d9ab35cc753', 'GREEN FLASH - SNOW - 15ML'),
('ba11ff3d-2c45-4076-8aa4-49336b39e910', 'GREEN FLASH - Mint 15ML'),
('cb70423c-626d-4b56-b3ce-f1513bb82d47', 'GREEN FLASH - Shell Beige 15ML'),
('d7308dbd-ed91-4e4e-ae58-9ee945964bbe', 'GREEN FLASH - Dark clover 15ML');

-- --------------------------------------------------------

--
-- Structure de la table `messenger_messages`
--

DROP TABLE IF EXISTS `messenger_messages`;
CREATE TABLE IF NOT EXISTS `messenger_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_75EA56E0FB7336F0` (`queue_name`),
  KEY `IDX_75EA56E0E3BD61CE` (`available_at`),
  KEY `IDX_75EA56E016BA31DB` (`delivered_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `order`
--

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deliver_to_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_number` int NOT NULL,
  `amount` double NOT NULL,
  `currency` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F52993986D7914CF` (`deliver_to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `order`
--

INSERT INTO `order` (`id`, `deliver_to_id`, `order_number`, `amount`, `currency`) VALUES
('083a171e-86f6-41ca-bd46-3d066e83d3ae', '99e06a8d-997c-4251-8cb7-27dab335ca1b', 326753, 171, 'EUR'),
('96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 'bf74b017-740b-4e34-8294-0df4fc1dee7e', 326756, 89, 'EUR');

-- --------------------------------------------------------

--
-- Structure de la table `order_line`
--

DROP TABLE IF EXISTS `order_line`;
CREATE TABLE IF NOT EXISTS `order_line` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderr_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double NOT NULL,
  `discount` double NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` double NOT NULL,
  `vat_amount` double NOT NULL,
  `vat_percentage` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_9CE58EE1126F525E` (`item_id`),
  KEY `IDX_9CE58EE17742FDB3` (`orderr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `order_line`
--

INSERT INTO `order_line` (`id`, `item_id`, `orderr_id`, `amount`, `discount`, `description`, `quantity`, `unit_code`, `unit_description`, `unit_price`, `vat_amount`, `vat_percentage`) VALUES
(1, '8f6bc422-a0b1-4975-9782-502babbbaa86', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Khaki 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(2, '3c393465-981e-4e85-b07e-13af762056c5', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Gold sand 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(3, '2470414f-772b-4217-9906-7750c63351e9', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Milky White 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(4, 'ba11ff3d-2c45-4076-8aa4-49336b39e910', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Mint 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(5, '978b685f-f059-432f-929d-e3e62db98217', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 0, 0, 'FRAIS DE TRANSPORT', 1, 'pc', 'Piece', 0, 0, 0.2),
(6, 'd7308dbd-ed91-4e4e-ae58-9ee945964bbe', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Dark clover 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(7, '62cf18c2-89ab-4bf1-ab34-4e598c17b7f4', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Dark pansy 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(8, '01c51e89-68e5-4ba4-a3b7-c76bf95ab92b', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Peach 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(9, 'cb70423c-626d-4b56-b3ce-f1513bb82d47', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Shell Beige 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(10, '40222201-93d1-4f2d-a56c-49bc060ad114', '083a171e-86f6-41ca-bd46-3d066e83d3ae', 15.83, -0.00021057064645192, 'GREEN FLASH - Navy Blue 15ML', 1, 'pc', 'Piece', 15.83, 3.17, 0.2),
(11, '82706172-4413-4ef9-937c-fa4eca30e21f', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 0, 'GREEN FLASH - Peonie 15ML', 1, 'pc', 'Piece', 0, 0, 0),
(12, '6c5b5c6e-1e78-41aa-a017-5127094625aa', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 74.17, 0.000044941800368482, 'GREEN FLASH - Coffret de Noel 24W - pre rempli', 1, 'pc', 'Piece', 74.17, 14.83, 0.2),
(13, 'b81e7448-8a45-4ff5-ba3a-0d9ab35cc753', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 1, 'GREEN FLASH - SNOW - 15ML', 1, 'pc', 'Piece', 15.83, 0, 0.2),
(14, '0d9cf810-fdd1-4b26-8ad2-c4c1f0c001f7', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 0, 'PUB -  Planche Stickers parfumes creme mains', 1, 'pc', 'Piece', 0, 0, 0.2),
(15, '64db5397-a0d2-4b28-b824-ff39a72ad341', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 0, 'GREEN FLASH - Light Blue 15ML', 1, 'pc', 'Piece', 0, 0, 0),
(16, '6905f992-6e55-489c-a369-4a5750c42177', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 0, 'ACC - PINCES DE DEPOSE X5', 1, 'pc', 'Piece', 0, 0, 0),
(17, '978b685f-f059-432f-929d-e3e62db98217', '96b66c2b-3081-48b8-b6a4-5977c12c2ca0', 0, 0, 'FRAIS DE TRANSPORT', 1, 'pc', 'Piece', 0, 0, 0.2);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `FK_F52993986D7914CF` FOREIGN KEY (`deliver_to_id`) REFERENCES `contact` (`id`);

--
-- Contraintes pour la table `order_line`
--
ALTER TABLE `order_line`
  ADD CONSTRAINT `FK_9CE58EE1126F525E` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`),
  ADD CONSTRAINT `FK_9CE58EE17742FDB3` FOREIGN KEY (`orderr_id`) REFERENCES `order` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
