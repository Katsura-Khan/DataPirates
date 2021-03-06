-- SQLite
CREATE TABLE logins (
	
user_login VARCHAR(15) NOT NULL,
user_password CHAR(30) NOT NULL,
PRIMARY KEY (user_login)
);

CREATE TABLE roles (

user_login VARCHAR(15) NOT NULL,
role_name VARCHAR(15) NOT NULL,
PRIMARY KEY (user_login, role_name)
);

CREATE TABLE student (

student_id INT(11) NOT NULL AUTO_INCREMENT,
student_name VARCHAR(60),
student_email VARCHAR(50),
program_name enum('Physics', 'Mathematics', 'Chemistry'),
student_year INT(10),
student_share TINYINT(1),
PRIMARY KEY (student_id)
);
CREATE TABLE Course (
	crsCode VARCHAR(255),
	deptId VARCHAR(255),
	crsName VARCHAR(255),
	descr VARCHAR(255)
);

CREATE TABLE Teaching (
	crsCode VARCHAR(255),
	semester VARCHAR(255),
	profId INT
);

CREATE TABLE Transcript (
	studId INT,
	crsCode VARCHAR(255),
	semester VARCHAR(255),
	grade VARCHAR(255)
);
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(50) NOT NULL DEFAULT '',
  `salt` varchar(50) NOT NULL DEFAULT '',
  `is_admin` bit(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
