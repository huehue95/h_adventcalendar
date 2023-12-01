CREATE TABLE `h_adventcalendar` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`luuku` INT(11) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE
);
