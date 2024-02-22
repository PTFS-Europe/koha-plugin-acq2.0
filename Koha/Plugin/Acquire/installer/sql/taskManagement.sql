CREATE TABLE IF NOT EXISTS { { workflow_tasks } } (
    `task_id` INT(11) NOT NULL AUTO_INCREMENT,
    `short_name` VARCHAR(50) DEFAULT '' COMMENT 'short name for the task',
    `module` VARCHAR(255) DEFAULT '' COMMENT 'module the task relates to',
    `description` longtext DEFAULT '' COMMENT 'description for the task',
    `created_on` DATETIME DEFAULT NULL COMMENT 'creation date of the task',
    `created_by` INT(11) DEFAULT NULL COMMENT 'person who created the task',
    `end_date` DATETIME DEFAULT NULL COMMENT 'target completion date of the task',
    `status` enum('assigned', 'complete', 'cancelled', 'on_hold') NOT NULL DEFAULT 'assigned' COMMENT 'is the task complete',
    `closed_on` DATETIME DEFAULT NULL COMMENT 'date the task was completed',
    `owner` INT(11) DEFAULT NULL COMMENT 'person the task is assigned to',
    PRIMARY KEY (`task_id`),
    FOREIGN KEY (`owner`) REFERENCES `borrowers` (`borrowernumber`),
    FOREIGN KEY (`created_by`) REFERENCES `borrowers` (`borrowernumber`)
) ENGINE = INNODB;