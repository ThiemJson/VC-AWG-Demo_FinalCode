-- Schema for Finance Management System
-- Target: Aiven MySQL (database: defaultdb)

CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(20) NULL,
  `profile_picture_url` VARCHAR(500) NULL,
  `total_balance` DECIMAL(15, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UQ_users_email` (`email`),
  UNIQUE KEY `UQ_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Accounts` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `bank_name` VARCHAR(255) NOT NULL,
  `account_type` ENUM('Checking', 'Credit Card', 'Savings', 'Investment', 'Loan') NOT NULL,
  `branch_name` VARCHAR(255) NULL,
  `account_number_full` VARCHAR(255) NOT NULL,
  `account_number_last_4` VARCHAR(4) NOT NULL,
  `balance` DECIMAL(15, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`account_id`),
  KEY `FK_accounts_user` (`user_id`),
  CONSTRAINT `FK_accounts_user` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Categories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `UQ_categories_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Transactions` (
  `transaction_id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `transaction_date` DATE NOT NULL,
  `type` ENUM('Revenue', 'Expense') NOT NULL,
  `item_description` VARCHAR(500) NOT NULL,
  `shop_name` VARCHAR(255) NULL,
  `amount` DECIMAL(15, 2) NOT NULL,
  `payment_method` VARCHAR(100) NULL,
  `status` ENUM('Complete', 'Pending', 'Failed') NOT NULL DEFAULT 'Pending',
  `receipt_id` VARCHAR(255) NULL,
  `category_id` INT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `FK_transactions_account` (`account_id`),
  KEY `FK_transactions_category` (`category_id`),
  CONSTRAINT `FK_transactions_account` FOREIGN KEY (`account_id`) REFERENCES `Accounts` (`account_id`),
  CONSTRAINT `FK_transactions_category` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Bills` (
  `bill_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `due_date` DATE NOT NULL,
  `logo_url` VARCHAR(500) NULL,
  `item_description` VARCHAR(500) NOT NULL,
  `last_charge_date` DATE NULL,
  `amount` DECIMAL(15, 2) NOT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `FK_bills_user` (`user_id`),
  CONSTRAINT `FK_bills_user` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Goals` (
  `goal_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `goal_type` ENUM('Saving', 'Expense_Limit') NOT NULL,
  `category_id` INT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `target_amount` DECIMAL(15, 2) NOT NULL,
  PRIMARY KEY (`goal_id`),
  KEY `FK_goals_user` (`user_id`),
  KEY `FK_goals_category` (`category_id`),
  CONSTRAINT `FK_goals_user` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `FK_goals_category` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed default categories
INSERT IGNORE INTO `Categories` (`category_name`) VALUES
  ('Food & Dining'),
  ('Transportation'),
  ('Shopping'),
  ('Entertainment'),
  ('Bills & Utilities'),
  ('Health & Fitness'),
  ('Education'),
  ('Travel'),
  ('Income'),
  ('Other');
