-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: movierecommendatrionsite
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actor`
--

DROP TABLE IF EXISTS `actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ActorName` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actor`
--

LOCK TABLES `actor` WRITE;
/*!40000 ALTER TABLE `actor` DISABLE KEYS */;
/*!40000 ALTER TABLE `actor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cast`
--

DROP TABLE IF EXISTS `cast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cast` (
  `MovieID` int NOT NULL,
  `ActorID` int NOT NULL,
  `MainSupporting` enum('Main','Supporting') DEFAULT NULL,
  PRIMARY KEY (`MovieID`,`ActorID`),
  KEY `ActorID_idx` (`ActorID`),
  KEY `ActorID_cast_idx` (`ActorID`),
  CONSTRAINT `ActorID_cast` FOREIGN KEY (`ActorID`) REFERENCES `actor` (`ID`),
  CONSTRAINT `MovieID_cast` FOREIGN KEY (`MovieID`) REFERENCES `movie` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cast`
--

LOCK TABLES `cast` WRITE;
/*!40000 ALTER TABLE `cast` DISABLE KEYS */;
/*!40000 ALTER TABLE `cast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `GenreID` int NOT NULL,
  `MovieID` int NOT NULL,
  `Genre` varchar(45) NOT NULL,
  PRIMARY KEY (`GenreID`,`MovieID`),
  KEY `MovieID_genre_idx` (`MovieID`),
  CONSTRAINT `GenreID_genre` FOREIGN KEY (`GenreID`) REFERENCES `genre_list` (`ID`),
  CONSTRAINT `MovieID_genre` FOREIGN KEY (`MovieID`) REFERENCES `movie` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre_list`
--

DROP TABLE IF EXISTS `genre_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre_list` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Genre` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre_list`
--

LOCK TABLES `genre_list` WRITE;
/*!40000 ALTER TABLE `genre_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `genre_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `ID` int NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Poster` mediumblob,
  `Director` varchar(45) NOT NULL,
  `MovieRating` decimal(2,1) DEFAULT NULL,
  `AveragePlayTime` int DEFAULT NULL,
  `AgeRating` enum('ALL','12','15','19') DEFAULT NULL,
  `Ranking` int DEFAULT NULL,
  `Synopsis` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` varchar(15) NOT NULL,
  `MovieID` int NOT NULL,
  `Rating` decimal(2,1) DEFAULT NULL,
  `Review` text,
  PRIMARY KEY (`ID`),
  KEY `UserID_idx` (`UserID`),
  KEY `MovieID_idx` (`MovieID`),
  CONSTRAINT `MovieID` FOREIGN KEY (`MovieID`) REFERENCES `movie` (`ID`),
  CONSTRAINT `UserID` FOREIGN KEY (`UserID`) REFERENCES `user` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_history`
--

DROP TABLE IF EXISTS `search_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `search_history` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `UserID` varchar(15) NOT NULL,
  `SearchHistory` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `UserID_search_idx` (`UserID`),
  CONSTRAINT `UserID_search` FOREIGN KEY (`UserID`) REFERENCES `user` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_history`
--

LOCK TABLES `search_history` WRITE;
/*!40000 ALTER TABLE `search_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `streaming_site`
--

DROP TABLE IF EXISTS `streaming_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `streaming_site` (
  `SiteID` int NOT NULL,
  `MovieID` int NOT NULL,
  PRIMARY KEY (`SiteID`,`MovieID`),
  KEY `MovieID_stream_idx` (`MovieID`),
  CONSTRAINT `MovieID_stream` FOREIGN KEY (`MovieID`) REFERENCES `movie` (`ID`),
  CONSTRAINT `SiteID_stream` FOREIGN KEY (`SiteID`) REFERENCES `streaming_site_list` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `streaming_site`
--

LOCK TABLES `streaming_site` WRITE;
/*!40000 ALTER TABLE `streaming_site` DISABLE KEYS */;
/*!40000 ALTER TABLE `streaming_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `streaming_site_list`
--

DROP TABLE IF EXISTS `streaming_site_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `streaming_site_list` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `StreamingSite` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `streaming_site_list`
--

LOCK TABLES `streaming_site_list` WRITE;
/*!40000 ALTER TABLE `streaming_site_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `streaming_site_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `ID` varchar(15) NOT NULL,
  `PW` varchar(255) NOT NULL,
  `BirthDate` date NOT NULL,
  `Name` varchar(50) NOT NULL,
  `NickName` varchar(255) NOT NULL,
  `Gender` enum('Male','Female') NOT NULL,
  `Email` varchar(320) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-13 12:24:28
