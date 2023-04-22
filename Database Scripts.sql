CREATE database jersey_review_website;
SHOW databases;
USE jersey_review_website;

/*Creating Tables*/
CREATE TABLE users (
  user_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  is_admin ENUM('regular','admin') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
);

DESCRIBE users;

CREATE TABLE soccer_team (
  team_id INT NOT NULL AUTO_INCREMENT,
  team_name VARCHAR(45) NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (team_id),
  KEY fk_soccer_team_user_id (user_id),
  CONSTRAINT fk_soccer_team_user_id FOREIGN KEY (user_id)
  REFERENCES users (user_id) ON UPDATE CASCADE
);

DESCRIBE soccer_team;

CREATE TABLE soccer_league (
  league_id INT NOT NULL AUTO_INCREMENT,
  league_name varchar(45) NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (league_id),
  KEY fk_soccer_league_user_id (user_id),
  CONSTRAINT fk_soccer_league_user_id 
  FOREIGN KEY (user_id) 
  REFERENCES users (user_id)
);

DESCRIBE soccer_league;

CREATE TABLE jersey (
  jersey_id INT NOT NULL AUTO_INCREMENT,
  team_id INT NOT NULL,
  image VARCHAR(255) NOT NULL,
  descriptiion VARCHAR(255) NOT NULL,
  `year` year NOT NULL,
  player_name VARCHAR(45) DEFAULT NULL,
  purchase_link VARCHAR(255) DEFAULT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (jersey_id),
  KEY fk_jersey_user_id (user_id),
  CONSTRAINT fk_jersey_user_id 
  FOREIGN KEY (user_id)
  REFERENCES users (user_id)
);

DESCRIBE jersey;

CREATE TABLE jersey_review (
  user_id INT NOT NULL,
  jersey_id INT NOT NULL,
  review_comment VARCHAR(258) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id , jersey_id),
  KEY fk_jersey_review_jersey_id (jersey_id),
  CONSTRAINT fk_jersey_review_jersey_id 
  FOREIGN KEY (jersey_id) 
  REFERENCES jersey (jersey_id),
  CONSTRAINT fk_jersey_review_user_id 
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

DESCRIBE jersey_review;

CREATE TABLE jersey_rating (
  user_id INT NOT NULL,
  jersey_id INT NOT NULL,
  rating_number TINYINT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, jersey_id),
  KEY fk_jersey_rating_jersey_id (jersey_id),
  CONSTRAINT fk_jersey_rating_jersey_id FOREIGN KEY (jersey_id) 
  REFERENCES jersey (jersey_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_jersey_rating_user_id FOREIGN KEY (user_id) 
  REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT jersey_rating_chk_1 CHECK (((rating_number > 0) AND (rating_number <= 5)))
);

DESCRIBE jersey_rating;

CREATE TABLE wish_item (
  wish_item_id INT NOT NULL AUTO_INCREMENT,
  jersey_id INT NOT NULL,
  created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (wish_item_id),
  KEY fk_wish_item_jersey_id (jersey_id),
  CONSTRAINT fk_wish_item_jersey_id FOREIGN KEY (jersey_id)
  REFERENCES jersey (jersey_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE login_info (
  login_id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (login_id),
  KEY fk_login_info_user_id (user_id),
  CONSTRAINT fk_login_info_user_id FOREIGN KEY (user_id) 
  REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

DESCRIBE login_info;

CREATE TABLE permission (
  permission_id INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  PRIMARY KEY (permission_id)
);

DESCRIBE permission;

CREATE TABLE league_team (
  league_id INT NOT NULL,
  team_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (league_id, team_id),
  KEY fk_league_team_team_id (team_id),
  CONSTRAINT fk_league_team_league_id FOREIGN KEY (league_id) 
  REFERENCES soccer_league (league_id),
  CONSTRAINT fk_league_team_team_id
  FOREIGN KEY (team_id) REFERENCES soccer_team (team_id)
);

DESCRIBE league_team;

CREATE TABLE user_wish (
  wish_item_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (wish_item_id, user_id),
  KEY fk_user_wish_user_id (user_id),
  CONSTRAINT fk_user_wish_user_id FOREIGN KEY (user_id) 
  REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_user_wish_wish_item_id FOREIGN KEY (wish_item_id) 
  REFERENCES wish_item (wish_item_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

DESCRIBE user_wish;

CREATE TABLE wish_item (
  wish_item_id INT NOT NULL AUTO_INCREMENT,
  jersey_id INT NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (wish_item_id),
  KEY fk_wish_item_jersey_id (jersey_id),
  CONSTRAINT fk_wish_item_jersey_id
  FOREIGN KEY (jersey_id) REFERENCES jersey (jersey_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

DESCRIBE wish_item;

CREATE TABLE user_permission (
  user_id INT NOT NULL,
  permission_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, permission_id),
  KEY fk_user_permission_permission_id (permission_id),
  CONSTRAINT fk_user_permission_permission_id FOREIGN KEY (permission_id) 
  REFERENCES permission (permission_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_user_permission_user_id
  FOREIGN KEY (user_id) 
  REFERENCES users (user_id)
);
DESCRIBE user_permission;
SHOW TABLES;

/*Alter Tables*/

ALTER TABLE users 
CHANGE COLUMN `is_admin` `is_admin` 
ENUM('regular', 'moderator', 'admin') NOT NULL;

ALTER TABLE jersey 
RENAME COLUMN descriptiion TO description;

/*Select, Update, Insert and Delete*/

SELECT * FROM users;
SELECT user_id, first_name, last_name FROM users;
UPDATE users SET first_name = 'Andre' WHERE user_id = 1;
INSERT INTO users (first_name, last_name, email, is_admin)
VALUES ('Lisa', 'Williams', 'lwilliams@gmail.com', 'moderator');
UPDATE users SET email = 'awilliams@gmail.com' WHERE user_id = 1;

SELECT * FROM jersey_review;
DELETE FROM jersey_review WHERE user_id = '4';

/*Use of Min, Max and AVG*/

SELECT MIN(rating_number) FROM jersey_rating;
SELECT MIN(rating_number), jersey_id FROM jersey_rating
group by jersey_id;

SELECT MAX(rating_number) 
AS 'Highest Rating' 
FROM jersey_rating;

SELECT MAX(rating_number) 
AS 'Highest Rated Jerseys', jersey_id 
FROM jersey_rating
group by jersey_id;

/*Use of Count, Distinct, Group By and Having*/

SELECT COUNT(user_id) 
AS 'Total Users' FROM users;

SELECT COUNT(*) FROM jersey;

SELECT AVG(rating_number) FROM jersey_rating;

SELECT * FROM jersey_rating;
SELECT user_id FROM jersey_rating;
SELECT DISTINCT user_id FROM jersey_rating;
SELECT COUNT(DISTINCT user_id) FROM jersey_rating;

SELECT jersey_id AS 'Ratings above 3'
FROM jersey_rating 
GROUP BY jersey_id
HAVING AVG(rating_number) > 3;

/*Use of Like, %, In, and Between*/

SELECT * FROM soccer_team WHERE team_name LIKE "%Manchester%";
SELECT * FROM users;
SELECT * FROM users WHERE first_name LIKE "A%";
SELECT * FROM users WHERE first_name IN ("John", "Lisa");

SELECT * FROM jersey_rating
WHERE rating_number BETWEEN 2 AND 4;

/*Performing JOIN Operations*/

SELECT * FROM jersey_rating
JOIN jersey
ON jersey_rating.jersey_id = jersey.jersey_id;
 
SELECT rating_number, jersey.description 
FROM jersey_rating
JOIN jersey
ON jersey_rating.jersey_id = jersey.jersey_id;

SELECT jersey.jersey_id, AVG(rating_number) AS 'Average Rating', jersey.description 
FROM jersey_rating
JOIN jersey
ON jersey_rating.jersey_id = jersey.jersey_id
GROUP BY jersey_id;

/*Creating Views*/

CREATE VIEW user_names AS
SELECT first_name, last_name
FROM users;

SELECT * FROM user_names;

SELECT * FROM soccer_league;
SELECT * FROM soccer_team;

CREATE VIEW team_league AS
SELECT
league_team.league_id,
league_team.team_id,
soccer_team.team_name,
soccer_league.league_name
FROM league_team
JOIN soccer_team ON league_team.team_id = soccer_team.team_id
JOIN soccer_league ON league_team.league_id = soccer_league.league_id;

SELECT * FROM team_league;

CREATE VIEW show_league_team AS
SELECT team_name, league_name
FROM league_team
JOIN soccer_team ON league_team.team_id = soccer_team.team_id
JOIN soccer_league ON league_team.league_id = soccer_league.league_id;

SELECT * FROM show_league_team;

/* Perform a Transaction with a rollback*/

START TRANSACTION;
INSERT INTO users(first_name, last_name, email)
VALUES('Simon', 'Peter', 'speter@gmail.com');
SELECT * FROM users;
ROLLBACK;
SELECT * FROM users;

/* Perform a Transaction with a commit*/

START TRANSACTION;
INSERT INTO users(first_name, last_name, email)
VALUES('Simon', 'Peter', 'speter@gmail.com');
SELECT * FROM users;
COMMIT;
SELECT * FROM users;

































    
   
    
    






  
  
  
  




