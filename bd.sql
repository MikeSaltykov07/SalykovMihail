-- MySQL Workbench Synchronization
-- Generated: 2019-04-15 13:51
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Михаил

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Collectives` (
  `Id_Collectives` INT(11) NOT NULL,
  `Name` VARCHAR(20) NOT NULL,
  `Info` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Id_Collectives`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Genres` (
  `Id` INT(11) NOT NULL,
  `Name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Group` (
  `Id` INT(11) NOT NULL,
  `Id_Collectives` INT(11) NOT NULL,
  `Date_Start` DATE NOT NULL,
  `Date_Finish` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`Id`, `Id_Collectives`),
  INDEX `fk_Composition_group_Collectives1_idx` (`Id_Collectives` ASC),
  CONSTRAINT `fk_Composition_group_Collectives1`
    FOREIGN KEY (`Id_Collectives`)
    REFERENCES `SaltykovMihail`.`Collectives` (`Id_Collectives`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`People` (
  `Id_People` INT(11) NOT NULL,
  `Nickname` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Surname` VARCHAR(45) NOT NULL,
  `Roles_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id_People`, `Roles_Id`),
  INDEX `fk_People_Roles1_idx` (`Roles_Id` ASC),
  CONSTRAINT `fk_People_Roles1`
    FOREIGN KEY (`Roles_Id`)
    REFERENCES `SaltykovMihail`.`Roles` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Roles` (
  `Id` INT(11) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Album` (
  `Id_Album` INT(11) NOT NULL,
  `Id_Composition` INT(11) NOT NULL,
  `Id_Collectives` INT(11) NOT NULL,
  `Id_genres` INT(11) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Year` YEAR NOT NULL,
  `Label` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id_Album`, `Id_Composition`, `Id_Collectives`, `Id_genres`),
  INDEX `fk_Album_Composition_group1_idx` (`Id_Composition` ASC),
  INDEX `fk_Album_Collectives1_idx` (`Id_Collectives` ASC),
  INDEX `fk_Album_Collectives_Genres1_idx` (`Id_genres` ASC),
  CONSTRAINT `fk_Album_Composition_group1`
    FOREIGN KEY (`Id_Composition`)
    REFERENCES `SaltykovMihail`.`Group` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Album_Collectives1`
    FOREIGN KEY (`Id_Collectives`)
    REFERENCES `SaltykovMihail`.`Collectives` (`Id_Collectives`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Album_Collectives_Genres1`
    FOREIGN KEY (`Id_genres`)
    REFERENCES `SaltykovMihail`.`Collectives_Genres` (`Id_genres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Collectives_Genres` (
  `Id_collectives` INT(11) NOT NULL,
  `Id_genres` INT(11) NOT NULL,
  PRIMARY KEY (`Id_collectives`, `Id_genres`),
  INDEX `fk_Collectives_has_Collectives_Genres_Collectives_Genres1_idx` (`Id_genres` ASC),
  INDEX `fk_Collectives_has_Collectives_Genres_Collectives1_idx` (`Id_collectives` ASC),
  CONSTRAINT `fk_Collectives_has_Collectives_Genres_Collectives1`
    FOREIGN KEY (`Id_collectives`)
    REFERENCES `SaltykovMihail`.`Collectives` (`Id_Collectives`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Collectives_has_Collectives_Genres_Collectives_Genres1`
    FOREIGN KEY (`Id_genres`)
    REFERENCES `SaltykovMihail`.`Genres` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Compositions` (
  `Id` INT(11) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Duration` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Album_Compositions` (
  `Id_album` INT(11) NOT NULL,
  `Id_compositions` INT(11) NOT NULL,
  PRIMARY KEY (`Id_album`, `Id_compositions`),
  INDEX `fk_Album_has_Compositions_Compositions1_idx` (`Id_compositions` ASC),
  INDEX `fk_Album_has_Compositions_Album1_idx` (`Id_album` ASC),
  CONSTRAINT `fk_Album_has_Compositions_Album1`
    FOREIGN KEY (`Id_album`)
    REFERENCES `SaltykovMihail`.`Album` (`Id_Album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Album_has_Compositions_Compositions1`
    FOREIGN KEY (`Id_compositions`)
    REFERENCES `SaltykovMihail`.`Compositions` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Group_People` (
  `Id_Composition` INT(11) NOT NULL,
  `Id_People` INT(11) NOT NULL,
  PRIMARY KEY (`Id_Composition`, `Id_People`),
  INDEX `fk_Composition_group_has_People_People1_idx` (`Id_People` ASC),
  INDEX `fk_Composition_group_has_People_Composition_group1_idx` (`Id_Composition` ASC),
  CONSTRAINT `fk_Composition_group_has_People_Composition_group1`
    FOREIGN KEY (`Id_Composition`)
    REFERENCES `SaltykovMihail`.`Group` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Composition_group_has_People_People1`
    FOREIGN KEY (`Id_People`)
    REFERENCES `SaltykovMihail`.`People` (`Id_People`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `SaltykovMihail`.`Author` (
  `Id_Author` INT(11) NOT NULL,
  `Id_compositions` INT(11) NOT NULL,
  PRIMARY KEY (`Id_Author`, `Id_compositions`),
  INDEX `fk_Author_Compositions1_idx` (`Id_compositions` ASC),
  INDEX `fk_Author_People1_idx` (`Id_Author` ASC),
  CONSTRAINT `fk_Author_Compositions1`
    FOREIGN KEY (`Id_compositions`)
    REFERENCES `SaltykovMihail`.`Compositions` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Author_People1`
    FOREIGN KEY (`Id_Author`)
    REFERENCES `SaltykovMihail`.`People` (`Id_People`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
