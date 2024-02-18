ALTER TABLE phone_tiktok_videos MODIFY COLUMN `src` VARCHAR(500) NOT NULL;
DROP PROCEDURE IF EXISTS tiktok_insert_notification_if_unique;