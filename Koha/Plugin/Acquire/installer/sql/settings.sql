CREATE TABLE IF NOT EXISTS { { settings } } (
  `variable` varchar(50) NOT NULL DEFAULT '' COMMENT 'system preference name',
  `value` mediumtext DEFAULT NULL COMMENT 'system preference values',
  `options` longtext DEFAULT NULL COMMENT 'options for multiple choice system preferences',
  `explanation` mediumtext DEFAULT NULL COMMENT 'descriptive text for the system preference',
  `type` varchar(20) DEFAULT NULL COMMENT 'type of question this preference asks (multiple choice, plain text, yes or no, etc)',
  PRIMARY KEY (`variable`)
) ENGINE = INNODB;