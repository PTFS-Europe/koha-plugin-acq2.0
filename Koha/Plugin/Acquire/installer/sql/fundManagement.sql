CREATE TABLE IF NOT EXISTS { { fiscal_year } } (
    `fiscal_yr_id` INT(11) NOT NULL AUTO_INCREMENT,
    `description` VARCHAR(255) DEFAULT '' COMMENT 'description for the fiscal year',
    `code` VARCHAR(255) DEFAULT '' COMMENT 'code for the fiscal year',
    `start_date` DATETIME DEFAULT NULL COMMENT 'start date of the event',
    `end_date` DATETIME DEFAULT NULL COMMENT 'end date of the event',
    `status` TINYINT(1) DEFAULT '1' COMMENT 'is the fiscal year currently active',
    `last_updated` DATETIME DEFAULT NULL COMMENT 'time of the last update to the fiscal year',
    `owner` INT(11) DEFAULT NULL COMMENT 'owner of the fiscal year',
    `lib_group` INT(11) DEFAULT NULL COMMENT 'library group the fiscal year applies to',
    PRIMARY KEY (`fiscal_yr_id`),
    FOREIGN KEY (`owner`) REFERENCES `borrowers` (`borrowernumber`),
    FOREIGN KEY (`lib_group`) REFERENCES `library_groups` (`id`)
) ENGINE = INNODB;