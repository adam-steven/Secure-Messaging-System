-- MySqlBackup.NET 2.0.9.2
-- Dump Time: 2019-11-23 22:08:32
-- --------------------------------------
-- Server version 5.5.64-MariaDB MariaDB Server


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- 
-- Definition of APP_ACCOUNT
-- 

DROP TABLE IF EXISTS `APP_ACCOUNT`;
CREATE TABLE IF NOT EXISTS `APP_ACCOUNT` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `usrename` (`username`),
  UNIQUE KEY `password` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table APP_ACCOUNT
-- 

/*!40000 ALTER TABLE `APP_ACCOUNT` DISABLE KEYS */;
INSERT INTO `APP_ACCOUNT`(`userID`,`username`,`password`) VALUES
(6,'test','a94a8fe5ccb19ba61c4c0873d391e987982fbbd3');
/*!40000 ALTER TABLE `APP_ACCOUNT` ENABLE KEYS */;

-- 
-- Definition of APP_APPOINTMENTS
-- 

DROP TABLE IF EXISTS `APP_APPOINTMENTS`;
CREATE TABLE IF NOT EXISTS `APP_APPOINTMENTS` (
  `studentUsername` varchar(50) NOT NULL,
  `staffForMeet` int(11) NOT NULL,
  `timeForMeet` time NOT NULL,
  `dateForMeet` date NOT NULL,
  `appointmentID` int(11) NOT NULL AUTO_INCREMENT,
  `department` varchar(30) NOT NULL,
  PRIMARY KEY (`appointmentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table APP_APPOINTMENTS
-- 

/*!40000 ALTER TABLE `APP_APPOINTMENTS` DISABLE KEYS */;

/*!40000 ALTER TABLE `APP_APPOINTMENTS` ENABLE KEYS */;

-- 
-- Definition of APP_STAFF_ACCOUNT
-- 

DROP TABLE IF EXISTS `APP_STAFF_ACCOUNT`;
CREATE TABLE IF NOT EXISTS `APP_STAFF_ACCOUNT` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `department` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table APP_STAFF_ACCOUNT
-- 

/*!40000 ALTER TABLE `APP_STAFF_ACCOUNT` DISABLE KEYS */;
INSERT INTO `APP_STAFF_ACCOUNT`(`id`,`name`,`department`) VALUES
(1,'William Voikok','Advice'),
(2,'Josh Walker','Advice'),
(3,'Fraser Mckinna','Advice'),
(4,'Sophie Lee','Advice'),
(5,'Rachel Nimmo','Advice'),
(6,'Patrick Watson','Finances'),
(7,'Ryan Cunningham','Finances'),
(8,'Annie Cayzer','Finances'),
(9,'Adam Kirk','Finances'),
(10,'Austin Thomas','Disability'),
(11,'Niamh Home','Disability'),
(12,'Leanne Murray','Disability'),
(13,'Jenny Campbell','Disability'),
(14,'Abigail Douglas','Disability'),
(15,'Clair Todd','Learning'),
(16,'Euan Penman','Learning'),
(17,'Jack Davidson','Learning'),
(18,'Lynn Buchanan','Health'),
(19,'Kara Nelson','Health'),
(20,'Carl McCann','Health'),
(21,'Robyn Donnelly','Health');
/*!40000 ALTER TABLE `APP_STAFF_ACCOUNT` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_ARTICLES
-- 

DROP TABLE IF EXISTS `COCKTAIL_ARTICLES`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_ARTICLES` (
  `a_id` int(11) NOT NULL AUTO_INCREMENT,
  `a_drink` varchar(25) NOT NULL,
  `a_ingredients` varchar(280) NOT NULL,
  `a_recipe` text NOT NULL,
  `a_author` varchar(25) NOT NULL,
  PRIMARY KEY (`a_id`),
  KEY `a_drink` (`a_drink`),
  CONSTRAINT `COCKTAIL_ARTICLES_ibfk_1` FOREIGN KEY (`a_drink`) REFERENCES `COCKTAIL_DRINKS` (`d_name`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_ARTICLES
-- 

/*!40000 ALTER TABLE `COCKTAIL_ARTICLES` DISABLE KEYS */;
INSERT INTO `COCKTAIL_ARTICLES`(`a_id`,`a_drink`,`a_ingredients`,`a_recipe`,`a_author`) VALUES
(1,'old fashioned ','2 parts whisky <br> 1 sugar cube <br> 3 dashes bitters ','1.Place a sugar cube in an Old Fashioned glass.\r\n<br> \r\n2.Saturate the cube with bitters.\r\n<br>\r\n3.Crush the sugar with a wooden muddler, then rotate the glass so that the sugar grains and bitters give it a lining.\r\n<br> \r\n4.Add a large ice cube. Pour in the whiskey. \r\n<br>\r\n5.Garnish with an orange twist.','John Calr'),
(2,'absinthe cocktail','1 sugar cube <br>\r\n1 part absinthe <br>\r\nwater\r\n','1.Pour the absinthe into an absinthe glass\r\n<br>\r\n2.Place an absinthe spoon on the glass\r\n<br>\r\n3.Place the sugar on top of the spoon\r\n<br>\r\n4.Slowly pour water on the sugar until it fully devolves. ','Sandra Di'),
(3,'bourbon mule','2 parts whisky\r\n<br> 1 tablespoon lime juice \r\n<br> ginger beer','1.In a copper mug pour in the whisky.\r\n<br>\r\n2.Add the lime juice. \r\n<br>\r\n3.Fill cup with crushed ice.\r\n<br>\r\n4.Top with ginger beer.\r\n<br> \r\n5.Garnish with mint sprig and lime slice.','Lew Hinder'),
(4,'cucumber cooler','5 mint leaves\r\n<br> 5 cucumber slices\r\n<br> 3 parts apple juice\r\n<br> 3 parts soda water','1.Add the mint and cucumber to a Collins glass.\r\n<br>\r\n2.Gently muddle the items in the glass.\r\n<br>\r\n3.Leave to stand for a couple of minutes.\r\n<br>\r\n4.Add the apple juice and soda water.\r\n<br>\r\n5.Garnish with a sprig of mint.','Adam Leavon'),
(5,'french 75','1 part gin\r\n<br> 3 teaspoons lemon juice\r\n<br> 3 teaspoons sugar syrup\r\n<br> 4 parts champagne ','1.Pour the gin, lemon juice and syrup into a cocktail shaker.\r\n<br>\r\n2.Shake well and strain into a flute glass. \r\n<br>\r\n3.Top with champagne.\r\n<br>\r\n4.Decorate with a lemon twist','Emily Sims'),
(6,'moscow mule','2 parts vodka\r\n<br> 1 tablespoon lime juice \r\n<br> ginger beer','1.In a copper mug pour in the vodka.\r\n<br>\r\n2.Add the lime juice. \r\n<br>\r\n3.Fill cup with crushed ice.\r\n<br>\r\n4.Top with ginger beer.\r\n<br> \r\n5.Garnish with mint sprig and lime slice.','Lew Hinder'),
(7,'pina colada','2 parts pineapple juice\r\n<br>\r\n1 part white rum\r\n<br>\r\n1 part coconut cream','1.Add all ingredients and ice to a blender\r\n<br>\r\n2.Pulse all the ingredients.\r\n<br>\r\n3.Pour into a tall glass (do not strain) \r\n<br>\r\n4.Garnish as you like.','Kate Jeo'),
(8,'sidecar','5 parts brandy <br>\r\n2 parts triple sec <br>\r\n2 parts lemon juice','1.Pour all ingredients into cocktail shaker.\r\n<br>\r\n2.Shake well. \r\n<br>\r\n3.Strain into cocktail glass.','Hannah Karr'),
(17,'spiked cider','4 parts cider <br>\r\n1 lemon slice <br>\r\n1 star anise <br>\r\n1 clove <br>\r\n1 part whisky','1.Add the cider, lemon, anise and clove to a pot.\r\n<br>\r\n2.Heat till simmering.\r\n<br>\r\n3.Pour the whisky into a mug.\r\n<br>\r\n4.Add 2 parts hot cider into the mug.','Greg Wazinski'),
(18,'tom collins','2 parts gin <br>\r\n1 part sugar syrup <br>\r\nsoda water','1. Add the gin, syrup and lemon juice to a cocktail shaker.\r\n<br>\r\n2.Shake well.\r\n<br>\r\n3.Strain into a Collins glass.\r\n<br>\r\n4.Top with soda water.\r\n<br>\r\n5.Decorate with a lemon wedge.','Peter Rose'),
(19,'white russian ','1 part coffee liqueur <br>\r\n1 part vodka <br>\r\n1 part cream ','1.Pour the coffee liqueur and vodka into a rocks glass.\r\n<br>\r\n2.stir.\r\n<br>\r\n3.Slowly add the cream (do not mix).','Karen Findi'),
(20,'watermelon smash','1 part tequila <br>\r\n4 chunks watermelon <br>\r\n5 mint leaves <br>\r\n1 teaspoon agave syrup','1.All all ingredient into a blender with ice.\r\n<br>\r\n2.Blender until smooth.\r\n<br>\r\n3.Pour everything into a glass.\r\n<br>\r\n4.Decorate with a mint sprig. ','Simon Smith'),
(21,'simple syrup','1 part sugar <br>\r\n1 part water','1.Add the sugar and water into a pot.\r\n<br>\r\n2.Heat and stir the mixture.\r\n<br>\r\n3.When the sugar is all gone, let cool.\r\n<br>\r\n4.Pour mixture into a container.\r\n<br>\r\n5.Store in refrigerator. ','Jill Jakobson'),
(22,'long island ice tea','1 part vodka <br>\r\n1 part gin <br>\r\n1 part white rum <br>\r\n1 part tequila <br>\r\n1 part cointreau <br>  \r\n1 part lemon juice\r\ncola','1.Add all ingredients, other than the cola, into a cocktail shaker.\r\n<br>\r\n2.Shake thoroughly.\r\n<br>\r\n3.Strain into 2 highball glasses.\r\n<br>\r\n4.Top with cola.\r\n<br>\r\n5.Garnish with lemon slices. ','Harris Far');
/*!40000 ALTER TABLE `COCKTAIL_ARTICLES` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_BASES
-- 

DROP TABLE IF EXISTS `COCKTAIL_BASES`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_BASES` (
  `b_type` varchar(30) NOT NULL,
  `b_image` varchar(255) NOT NULL,
  `b_description` varchar(280) NOT NULL,
  PRIMARY KEY (`b_type`),
  UNIQUE KEY `type` (`b_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_BASES
-- 

/*!40000 ALTER TABLE `COCKTAIL_BASES` DISABLE KEYS */;
INSERT INTO `COCKTAIL_BASES`(`b_type`,`b_image`,`b_description`) VALUES
('absinthe / bitters','absintheCocktail.jpg','Cocktails that include high ABV ratios.'),
('brandy','Sidecarl.jpg','Cocktails that include brandy.'),
('cider ','spikedCider.jpg','Cocktails that include cider.'),
('gin','tomCollins.jpg','Cocktails that include gin.'),
('liqueur','whiteRussian.jpg','Cocktails that include liqueur.'),
('mocktails ','cucumberCooler.jpg','Drinks with no alcohol in them. '),
('rum','pinaCloada.jpg','Cocktails that include rum.'),
('syrup','syrup.png','Drink sweetener recipes. '),
('tequila','watermelonSmash.jpg','Cocktails that include tequila.'),
('vodka','moscowMule.jpg','Cocktails that include vodka.'),
('whisky ','oldFashioned.jpg','Cocktails that include whisky.'),
('wine','french75.jpg','Cocktails that include wine.');
/*!40000 ALTER TABLE `COCKTAIL_BASES` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_COMMENTS
-- 

DROP TABLE IF EXISTS `COCKTAIL_COMMENTS`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_COMMENTS` (
  `c_id` int(11) NOT NULL AUTO_INCREMENT,
  `c_user` varchar(25) NOT NULL,
  `c_articleID` int(11) NOT NULL,
  `c_comment` varchar(280) NOT NULL,
  PRIMARY KEY (`c_id`),
  KEY `c_user` (`c_user`),
  KEY `c_articleID` (`c_articleID`),
  CONSTRAINT `COCKTAIL_COMMENTS_ibfk_2` FOREIGN KEY (`c_articleID`) REFERENCES `COCKTAIL_ARTICLES` (`a_id`),
  CONSTRAINT `COCKTAIL_COMMENTS_ibfk_3` FOREIGN KEY (`c_user`) REFERENCES `COCKTAIL_USERS` (`u_username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_COMMENTS
-- 

/*!40000 ALTER TABLE `COCKTAIL_COMMENTS` DISABLE KEYS */;
INSERT INTO `COCKTAIL_COMMENTS`(`c_id`,`c_user`,`c_articleID`,`c_comment`) VALUES
(2,'user',1,'this is a test'),
(3,'user',1,'2 test'),
(7,'test',1,'testtt'),
(8,'test',1,'testttttttttt'),
(9,'test',1,'fo'),
(10,'test',1,'t'),
(11,'test',1,'fth');
/*!40000 ALTER TABLE `COCKTAIL_COMMENTS` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_DRINKS
-- 

DROP TABLE IF EXISTS `COCKTAIL_DRINKS`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_DRINKS` (
  `d_id` int(11) NOT NULL AUTO_INCREMENT,
  `d_name` varchar(25) NOT NULL,
  `d_base` varchar(50) NOT NULL,
  PRIMARY KEY (`d_id`),
  KEY `base` (`d_base`),
  KEY `d_name` (`d_name`),
  CONSTRAINT `COCKTAIL_DRINKS_ibfk_1` FOREIGN KEY (`d_base`) REFERENCES `COCKTAIL_BASES` (`b_type`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_DRINKS
-- 

/*!40000 ALTER TABLE `COCKTAIL_DRINKS` DISABLE KEYS */;
INSERT INTO `COCKTAIL_DRINKS`(`d_id`,`d_name`,`d_base`) VALUES
(1,'absinthe cocktail','absinthe / bitters'),
(2,'old fashioned ','whisky '),
(3,'cucumber cooler','mocktails '),
(4,'french 75','wine'),
(5,'moscow mule','vodka'),
(7,'pina colada','rum'),
(8,'sidecar','brandy'),
(9,'spiked cider','cider '),
(10,'tom collins','gin'),
(11,'watermelon smash','tequila'),
(12,'bourbon mule','whisky '),
(13,'white russian ','liqueur'),
(14,'french 75','gin'),
(15,'spiked cider','whisky '),
(16,'white russian','vodka'),
(17,'simple syrup','syrup'),
(18,'long island ice tea','vodka'),
(19,'long island ice tea','gin'),
(20,'long island ice tea','rum'),
(21,'long island ice tea','tequila'),
(22,'long island ice tea','liqueur');
/*!40000 ALTER TABLE `COCKTAIL_DRINKS` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_IMAGES
-- 

DROP TABLE IF EXISTS `COCKTAIL_IMAGES`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_IMAGES` (
  `i_id` int(11) NOT NULL AUTO_INCREMENT,
  `i_drink` varchar(25) NOT NULL,
  `i_image` varchar(255) NOT NULL,
  PRIMARY KEY (`i_id`),
  KEY `i_article` (`i_drink`),
  CONSTRAINT `COCKTAIL_IMAGES_ibfk_1` FOREIGN KEY (`i_drink`) REFERENCES `COCKTAIL_DRINKS` (`d_name`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_IMAGES
-- 

/*!40000 ALTER TABLE `COCKTAIL_IMAGES` DISABLE KEYS */;
INSERT INTO `COCKTAIL_IMAGES`(`i_id`,`i_drink`,`i_image`) VALUES
(1,'absinthe cocktail','absintheCocktail.jpg'),
(2,'cucumber cooler','cucumberCooler.jpg'),
(3,'french 75','french75.jpg'),
(4,'moscow mule','moscowMule.jpg'),
(5,'old fashioned ','oldFashioned.jpg'),
(6,'sidecar','Sidecarl.jpg'),
(7,'tom collins','tomCollins.jpg'),
(8,'pina colada','pinaCloada.jpg'),
(9,'watermelon smash','watermelonSmash.jpg'),
(10,'white russian ','whiteRussian.jpg'),
(11,'spiked cider','spikedCider.jpg'),
(12,'old fashioned ','cTest1.png'),
(13,'old fashioned ','cTest2.png'),
(14,'simple syrup','syrup.png'),
(15,'absinthe cocktail','cTest1.png'),
(16,'spiked cider','cTest1.png'),
(17,'spiked cider','cTest2.png'),
(18,'long island ice tea','cTest1.png'),
(19,'tom collins','cTest1.png'),
(20,'tom collins','cTest2.png'),
(21,'cucumber cooler','cTest1.png'),
(22,'simple syrup','cTest1.png'),
(23,'moscow mule','cTest1.png'),
(24,'bourbon mule','cTest1.png'),
(25,'bourbon mule','cTest2.png');
/*!40000 ALTER TABLE `COCKTAIL_IMAGES` ENABLE KEYS */;

-- 
-- Definition of COCKTAIL_USERS
-- 

DROP TABLE IF EXISTS `COCKTAIL_USERS`;
CREATE TABLE IF NOT EXISTS `COCKTAIL_USERS` (
  `u_username` varchar(25) NOT NULL,
  `u_password` varchar(256) NOT NULL,
  `u_email` varchar(30) NOT NULL,
  `u_phone` varchar(13) NOT NULL,
  PRIMARY KEY (`u_email`),
  UNIQUE KEY `u_username` (`u_username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table COCKTAIL_USERS
-- 

/*!40000 ALTER TABLE `COCKTAIL_USERS` DISABLE KEYS */;
INSERT INTO `COCKTAIL_USERS`(`u_username`,`u_password`,`u_email`,`u_phone`) VALUES
('gg','$2y$15$Xqv0pdLpU1gLKi0XH4/Uruq.Y8Wa3RqDcAP16cbQa5xEknF8KEMCe','gg@gg.com','00000000000'),
('hi','$2y$15$.Tu9p0ayr26kqG5TmZ6sdOq5Em2AUjPb4Y8d0sq4A8j3PIB7QZ/R6','hi@hi.com','00000000000'),
('t','$2y$15$N9GrX9Rr3zzo.mivt9mS0uHksiPoHBGJOpuxC9V06EFvPVhL5eT.G','t','t'),
('test','$2y$15$k//T3DcQXUMUU3XbEOb5QOtw2FYk3xSYIUKAyijYa717cP1dhVmGK','test@test.com',''),
('user','$2y$10$R3VGj1VQoqSNOEOQx9sG2ekAJ5U9GDsVH7QSLBccLergDod/o1qeO','user@live.com',''),
('yes','$2y$15$XLz/QpUrKsLk2XuFlwZDd.GaxmAFaE1gtR1MzYtZEADOzpomqGaVK','yes','');
/*!40000 ALTER TABLE `COCKTAIL_USERS` ENABLE KEYS */;

-- 
-- Definition of DOGE_CONVO
-- 

DROP TABLE IF EXISTS `DOGE_CONVO`;
CREATE TABLE IF NOT EXISTS `DOGE_CONVO` (
  `MessageId` int(11) NOT NULL AUTO_INCREMENT,
  `SenderId` int(11) NOT NULL,
  `ReceiverId` int(11) NOT NULL,
  `Message` varbinary(512) NOT NULL,
  `ReadMessage` tinyint(1) NOT NULL,
  `Important` tinyint(1) NOT NULL,
  `DateStamp` date NOT NULL,
  `aesiv` varbinary(512) NOT NULL,
  PRIMARY KEY (`MessageId`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table DOGE_CONVO
-- 

/*!40000 ALTER TABLE `DOGE_CONVO` DISABLE KEYS */;
INSERT INTO `DOGE_CONVO`(`MessageId`,`SenderId`,`ReceiverId`,`Message`,`ReadMessage`,`Important`,`DateStamp`,`aesiv`) VALUES
(25,1,2,0xA4DA0378D95FC2C23E59F2FE5AA36D68,1,0,'2019-11-23 00:00:00',0x1FC2A5EFABE1F4F9B395D4317F3F6A1C),
(26,1,2,0x7555CEB19E39F26F4CE79678CB03472C,1,0,'2019-11-23 00:00:00',0xB6F4965BD100AF47B6D0A1A0DC9CEF86),
(27,1,2,0x0076DA80937305F0E6642C378B42EA43,1,0,'2019-11-23 00:00:00',0xA0B4BE80DC2DD6A81CA9E04DB0E7EFA1),
(28,1,2,0x5E3BC65C3C0E6192C13838ECC3B16611,1,0,'2019-11-23 00:00:00',0x5B57323330331DE93685C77E8670B949);
/*!40000 ALTER TABLE `DOGE_CONVO` ENABLE KEYS */;

-- 
-- Definition of DOGE_USERS
-- 

DROP TABLE IF EXISTS `DOGE_USERS`;
CREATE TABLE IF NOT EXISTS `DOGE_USERS` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(25) NOT NULL,
  `Password` varbinary(512) NOT NULL,
  `UniqueIdentifier` varbinary(512) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table DOGE_USERS
-- 

/*!40000 ALTER TABLE `DOGE_USERS` DISABLE KEYS */;
INSERT INTO `DOGE_USERS`(`id`,`Username`,`Password`,`UniqueIdentifier`) VALUES
(1,'John Canber',0xA9A6E40EFA1FAD9C6790876A9F3D289F40A3E8E6FF631487C4584C62A34F1DF1,0xC1C9AA44D3355D2B66B3E5668603336C89812083F9915D4308C5907C36B221B1),
(2,'Fraser Bori',0xE03456422C80DC30937835C3AC8934BA,0xF7BEA390DE62C1D835F2453BC9F001F84BC03AFD2F3AE8652259BE9346BEE888),
(3,'Sandra Parr',0x5C8BA6BD71734D698FD90EBCB977A291,0x351A2331CA2B4A4B00702A767CBAB2B346CE441A51984BA0CA5F26CBB11735D9),
(4,'Clair Haderstone',0x1AF65FEDA58594C8443B91702CBB7317,0x4E4F12A4706DC8818D28DC482BFB3B283EEA3B53AD12BD1BF6B7A2F0970A5883),
(5,'Josh Rivet',0x9801517544EF5BDCD30C780716F5FA19,0x23817A233863108415CD0CF92EBFDABCB833D90C017A408C0AA9134F3FADA845),
(6,'Hannah Koprick',0x980E997CD66F352ECA7AF408DC48C6863E7695B956D547EDC2D1E891AC900A2C,0xA091AA41378E6DE2AA6EE9345790B0EE1952AE14CFF9F777F7D10CFC4E68B714);
/*!40000 ALTER TABLE `DOGE_USERS` ENABLE KEYS */;

-- 
-- Definition of DOGE_USER_SECURITY
-- 

DROP TABLE IF EXISTS `DOGE_USER_SECURITY`;
CREATE TABLE IF NOT EXISTS `DOGE_USER_SECURITY` (
  `userID` int(11) NOT NULL,
  `passKey` varbinary(512) NOT NULL,
  `passIV` varbinary(512) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table DOGE_USER_SECURITY
-- 

/*!40000 ALTER TABLE `DOGE_USER_SECURITY` DISABLE KEYS */;
INSERT INTO `DOGE_USER_SECURITY`(`userID`,`passKey`,`passIV`) VALUES
(1,0x7D81766B688F0F7358CEDB14D094F876A7E73BAAF15070C2888FED740229537B,0x92310876D1E30FCE44006E59047ACEB7),
(2,0x21F85DA086D426E242414B4F7BA43A6B2B653A85F6BAA4EB6049F0EAB4D194F7,0x92E0B1F2994423C1649176AF1A4B31F2),
(3,0xE719218EE2AA30A6A81003356EA602035952FBEA3B222505BA6FD05B71EC31BB,0xF36A4DE18B6F023F080BC2363ABC41B8),
(4,0x886037EFC586A687AC3B1D5FDB89B1769382BEE7D1E0A9802A3C391795740990,0xB4CA7D581A6E96FD7CAC68DE4D455C4D),
(5,0x92811E85656C1E4037E98A77921A26238AE8D3CC98377B4FAC5CD24D0220AFE8,0x1BDDEC4BB14ABEB2BA34EF64EA5DACD0),
(6,0x5FF83AFC225516D6B33ADDDCE8CEC3697964CA2806A20EAADFFDFE98D85ADB14,0x5A07B2115E74FC91846DBB53AD75AD38);
/*!40000 ALTER TABLE `DOGE_USER_SECURITY` ENABLE KEYS */;

-- 
-- Definition of ELECTRIC_IMP
-- 

DROP TABLE IF EXISTS `ELECTRIC_IMP`;
CREATE TABLE IF NOT EXISTS `ELECTRIC_IMP` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `external` float NOT NULL,
  `internal` float NOT NULL,
  `light` float NOT NULL,
  `voltage` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table ELECTRIC_IMP
-- 

/*!40000 ALTER TABLE `ELECTRIC_IMP` DISABLE KEYS */;
INSERT INTO `ELECTRIC_IMP`(`id`,`external`,`internal`,`light`,`voltage`) VALUES
(1,1,1,1,1),
(2,26.2,26,62463,3.284),
(3,26.2,26,62463,3.286),
(4,21.2,25.9,62463,3.288),
(5,20.6,25.8,62463,3.286),
(6,23.6,25.9,62495,3.284),
(7,24.8,25.9,62495,3.288),
(8,26.4,26.6,62063,3.284),
(9,26.5,26.5,62255,3.284),
(10,26.3,26.3,58878,3.284),
(11,26.2,26.3,60574,3.284),
(12,26.1,26.3,61919,3.288),
(13,26.3,26.2,60350,3.288),
(14,26.2,26.2,58302,3.288),
(15,26.1,26.1,61967,3.286),
(16,26.1,26,61791,3.284),
(17,26.1,26,61599,3.284),
(18,25.8,26,62047,3.282),
(19,26.3,26,62111,3.286),
(20,25.6,26,61727,3.282),
(21,25.7,25.9,61374,3.288),
(22,25.7,25.9,59390,3.284),
(23,25.3,25.9,62319,3.282),
(24,28.3,26.9,62271,3.286),
(25,28.3,26.9,61791,3.284),
(26,28.3,26.9,61807,3.284),
(27,28.3,27,61855,3.284),
(28,28.1,27.1,61791,3.286),
(29,28,27.1,61567,3.284),
(30,28,27.1,61855,3.284),
(31,28,27.1,61855,3.284),
(32,28.1,27.2,61855,3.284),
(33,28.1,27.3,61887,3.284),
(34,28,27.3,61983,3.288),
(35,27.9,27.3,61951,3.286),
(36,28,27.4,61951,3.286),
(37,28,27.3,61951,3.286),
(38,26.2,26.8,61615,3.286),
(39,25.8,26.4,47099,3.288);
/*!40000 ALTER TABLE `ELECTRIC_IMP` ENABLE KEYS */;

-- 
-- Definition of WEB_CHECKOUT_PRODUCT
-- 

DROP TABLE IF EXISTS `WEB_CHECKOUT_PRODUCT`;
CREATE TABLE IF NOT EXISTS `WEB_CHECKOUT_PRODUCT` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `productID` varchar(50) NOT NULL,
  `customerID` varchar(50) NOT NULL,
  PRIMARY KEY (`counter`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table WEB_CHECKOUT_PRODUCT
-- 

/*!40000 ALTER TABLE `WEB_CHECKOUT_PRODUCT` DISABLE KEYS */;
INSERT INTO `WEB_CHECKOUT_PRODUCT`(`counter`,`productID`,`customerID`) VALUES
(2,'C000000','1'),
(4,'C000000','2');
/*!40000 ALTER TABLE `WEB_CHECKOUT_PRODUCT` ENABLE KEYS */;

-- 
-- Definition of WEB_CONCERT_INFO
-- 

DROP TABLE IF EXISTS `WEB_CONCERT_INFO`;
CREATE TABLE IF NOT EXISTS `WEB_CONCERT_INFO` (
  `productID` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `tickets_left` int(11) NOT NULL,
  PRIMARY KEY (`productID`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table WEB_CONCERT_INFO
-- 

/*!40000 ALTER TABLE `WEB_CONCERT_INFO` DISABLE KEYS */;
INSERT INTO `WEB_CONCERT_INFO`(`productID`,`name`,`tickets_left`) VALUES
('C000000','the day after concert',50);
/*!40000 ALTER TABLE `WEB_CONCERT_INFO` ENABLE KEYS */;

-- 
-- Definition of WEB_PROFILES
-- 

DROP TABLE IF EXISTS `WEB_PROFILES`;
CREATE TABLE IF NOT EXISTS `WEB_PROFILES` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `staff` tinyint(1) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table WEB_PROFILES
-- 

/*!40000 ALTER TABLE `WEB_PROFILES` DISABLE KEYS */;
INSERT INTO `WEB_PROFILES`(`userID`,`username`,`password`,`staff`) VALUES
(1,'username','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',0),
(2,'tester1','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',0),
(3,'userr','da4b9237bacccdf19c0760cab7aec4a8359010b0',0),
(4,'test','a94a8fe5ccb19ba61c4c0873d391e987982fbbd3',0),
(5,'t','8efd86fb78a56a5145ed7739dcb00c78581c5375',0),
(6,'tt','8efd86fb78a56a5145ed7739dcb00c78581c5375',0);
/*!40000 ALTER TABLE `WEB_PROFILES` ENABLE KEYS */;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


-- Dump completed on 2019-11-23 22:08:35
-- Total time: 0:0:0:3:496 (d:h:m:s:ms)
