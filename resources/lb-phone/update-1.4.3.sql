ALTER TABLE `phone_photos` MODIFY COLUMN `link` VARCHAR(500) NOT NULL;
ALTER TABLE `phone_voice_memos_recordings` MODIFY COLUMN `file_url` VARCHAR(500) NOT NULL;
ALTER TABLE `phone_phone_voicemail` MODIFY COLUMN `url` VARCHAR(500) NOT NULL;