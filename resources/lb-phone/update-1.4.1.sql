ALTER TABLE phone_twitter_accounts ADD COLUMN `private` BOOLEAN DEFAULT FALSE;
ALTER TABLE phone_instagram_accounts ADD COLUMN `private` BOOLEAN DEFAULT FALSE;

UPDATE phone_twitter_accounts a
SET a.follower_count = (
  SELECT COUNT(f.follower)
  FROM phone_twitter_follows f
  WHERE f.followed = a.username
), a.following_count = (
  SELECT COUNT(f.followed)
  FROM phone_twitter_follows f
  WHERE f.follower = a.username
);

ALTER TABLE phone_instagram_accounts ADD COLUMN post_count INT(11) NOT NULL DEFAULT 0 AFTER bio;
ALTER TABLE phone_instagram_accounts ADD COLUMN story_count INT(11) NOT NULL DEFAULT 0 AFTER post_count;
ALTER TABLE phone_instagram_accounts ADD COLUMN follower_count INT(11) NOT NULL DEFAULT 0 AFTER story_count;
ALTER TABLE phone_instagram_accounts ADD COLUMN following_count INT(11) NOT NULL DEFAULT 0 AFTER follower_count;

UPDATE phone_instagram_accounts a
SET a.follower_count = (
  SELECT COUNT(f.follower)
  FROM phone_instagram_follows f
  WHERE f.followed = a.username
), a.following_count = (
  SELECT COUNT(f.followed)
  FROM phone_instagram_follows f
  WHERE f.follower = a.username
), a.post_count = (
  SELECT COUNT(p.id)
  FROM phone_instagram_posts p
  WHERE p.username = a.username
), a.story_count = (
  SELECT COUNT(s.username)
  FROM phone_instagram_stories s
  WHERE s.username = a.username
);

ALTER TABLE phone_phones ADD COLUMN owner VARCHAR(100) AFTER id;