CREATE TABLE IF NOT EXISTS { { fiscal_year } } (
    `fiscal_yr_id` INT(11) NOT NULL AUTO_INCREMENT,
    `description` VARCHAR(255) DEFAULT '' COMMENT 'description for the fiscal year',
    `code` VARCHAR(255) DEFAULT '' COMMENT 'code for the fiscal year',
    `start_date` date DEFAULT NULL COMMENT 'start date of the event',
    `end_date` date DEFAULT NULL COMMENT 'end date of the event',
    `status` TINYINT(1) DEFAULT '1' COMMENT 'is the fiscal year currently active',
    `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'time of the last update to the fiscal year',
    `owner` INT(11) DEFAULT NULL COMMENT 'owner of the fiscal year',
    `visible_to` VARCHAR(255) DEFAULT '' COMMENT 'library groups the fiscal year is visible to',
    PRIMARY KEY (`fiscal_yr_id`),
    FOREIGN KEY (`owner`) REFERENCES `borrowers` (`borrowernumber`)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS { { ledgers } } (
    `ledger_id` INT(11) NOT NULL AUTO_INCREMENT,
    `fiscal_yr_id` INT(11) DEFAULT NULL COMMENT 'fiscal year the ledger applies to',
    `name` VARCHAR(255) DEFAULT '' COMMENT 'name for the ledger',
    `description` VARCHAR(255) DEFAULT '' COMMENT 'description for the ledger',
    `code` VARCHAR(255) DEFAULT '' COMMENT 'code for the ledger',
    `external_id` VARCHAR(255) DEFAULT '' COMMENT 'external id for the ledger for use with external accounting systems',
    `currency` VARCHAR(10) DEFAULT '' COMMENT 'currency of the ledger',
    `status` TINYINT(1) DEFAULT '1' COMMENT 'is the ledger currently active',
    `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'time of the last update to the ledger',
    `owner` INT(11) DEFAULT NULL COMMENT 'owner of the ledger',
    `visible_to` VARCHAR(255) DEFAULT '' COMMENT 'library groups the ledger is visible to',
    `over_spend_allowed` TINYINT(1) DEFAULT '1' COMMENT 'is an overspend allowed on the ledger',
    `over_encumbrance_allowed` TINYINT(1) DEFAULT '1' COMMENT 'is an overencumbrance allowed on the ledger',
    `oe_warning_percent` decimal(5,4) DEFAULT 0.0000 COMMENT 'percentage limit for overencumbrance',
    `oe_limit_amount` decimal(28,6) DEFAULT 0.000000 COMMENT 'limit for overspend',
    `os_warning_sum` decimal(28,6) DEFAULT 0.000000 COMMENT 'amount to trigger a warning for overspend',
    `os_limit_sum` decimal(28,6) DEFAULT 0.000000 COMMENT 'amount to trigger a block on the ledger for overspend',
    PRIMARY KEY (`ledger_id`),
    FOREIGN KEY (`fiscal_yr_id`) REFERENCES { { fiscal_year } } (`fiscal_yr_id`),
    FOREIGN KEY (`owner`) REFERENCES `borrowers` (`borrowernumber`)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS { { funds } } (
    `fund_id` INT(11) NOT NULL AUTO_INCREMENT,
    `ledger_id` INT(11) DEFAULT NULL COMMENT 'ledger the fund applies to',
    `fiscal_yr_id` INT(11) DEFAULT NULL COMMENT 'fiscal year the fund applies to',
    `name` VARCHAR(255) DEFAULT '' COMMENT 'name for the fund',
    `description` VARCHAR(255) DEFAULT '' COMMENT 'description for the fund',
    `fund_type` VARCHAR(255) DEFAULT '' COMMENT 'type for the fund',
    `code` VARCHAR(255) DEFAULT '' COMMENT 'code for the fund',
    `external_id` VARCHAR(255) DEFAULT '' COMMENT 'external id for the fund for use with external accounting systems',
    `currency` VARCHAR(10) DEFAULT '' COMMENT 'currency of the fund',
    `status` TINYINT(1) DEFAULT '1' COMMENT 'is the fund currently active',
    `owner` INT(11) DEFAULT NULL COMMENT 'owner of the fund',
    `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'time of the last update to the fund',
    `visible_to` VARCHAR(255) DEFAULT '' COMMENT 'library groups the fund is visible to',
    PRIMARY KEY (`fund_id`),
    FOREIGN KEY (`ledger_id`) REFERENCES { { ledgers } } (`ledger_id`),
    FOREIGN KEY (`fiscal_yr_id`) REFERENCES { { fiscal_year } } (`fiscal_yr_id`),
    FOREIGN KEY (`owner`) REFERENCES `borrowers` (`borrowernumber`)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS { { fund_allocation } } (
    `fund_allocation_id` INT(11) NOT NULL AUTO_INCREMENT,
    `fund_id` INT(11) DEFAULT NULL COMMENT 'ledger the fund applies to',
    `allocation_amout` decimal(28,6) DEFAULT 0.000000 COMMENT 'amount for the allocation',
    `reference` VARCHAR(255) DEFAULT '' COMMENT 'allocation reference',
    `note` VARCHAR(255) DEFAULT '' COMMENT 'any notes associated to the reference',
    `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'time of the last update to the fund',
    `visible_to` VARCHAR(255) DEFAULT '' COMMENT 'library groups the fund allocation is visible to',
    PRIMARY KEY (`fund_allocation_id`),
    FOREIGN KEY (`fund_id`) REFERENCES { { funds } } (`fund_id`)
) ENGINE = INNODB;