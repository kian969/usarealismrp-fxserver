-- Increase image length
ALTER TABLE phone_notifications MODIFY COLUMN thumbnail VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_notifications MODIFY COLUMN avatar VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_twitter_accounts MODIFY COLUMN profile_image VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_twitter_accounts MODIFY COLUMN profile_header VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_phone_contacts MODIFY COLUMN profile_image VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_instagram_accounts MODIFY COLUMN profile_image VARCHAR(500) DEFAULT NULL;
ALTER TABLE phone_instagram_stories MODIFY COLUMN `image` VARCHAR(500) NOT NULL;
ALTER TABLE phone_tiktok_accounts MODIFY COLUMN avatar VARCHAR(500) DEFAULT NULL;
-- Rename columns
ALTER TABLE phone_last_phone RENAME COLUMN identifier TO id;
ALTER TABLE phone_crypto RENAME COLUMN identifier TO id;
ALTER TABLE phone_backups RENAME COLUMN identifier TO id;
ALTER TABLE phone_phones RENAME COLUMN owner TO owner_id;