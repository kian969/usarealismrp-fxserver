ALTER TABLE phone_message_members ADD COLUMN deleted BOOLEAN NOT NULL DEFAULT FALSE after is_owner;
ALTER TABLE phone_message_members ADD COLUMN unread INT NOT NULL DEFAULT 0 after deleted;
DROP TABLE phone_message_unread;