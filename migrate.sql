truncate channels cascade;

insert into channels (
  id,
  name,
  twitter_hashtag,
  inserted_at,
  updated_at
) select
  lc.id,
  lc.name,
  lc.twitter_hashtag,
  lc.created_at,
  lc.updated_at
from legacy.channels as lc;

select setval('channels_id_seq', (select max(id) from legacy.channels));

insert into posts (
  id,
  title,
  body,
  inserted_at,
  updated_at,
  channel_id,
  slug,
  likes,
  max_likes,
  published_at,
  tweeted
) select
  lp.id,
  lp.title,
  lp.body,
  lp.created_at,
  lp.updated_at,
  lp.channel_id,
  lp.slug,
  lp.likes,
  lp.max_likes,
  lp.published_at,
  lp.tweeted
from legacy.posts as lp
where lp.published_at is not null;

select setval('posts_id_seq', (select max(id) from legacy.posts));
