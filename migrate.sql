truncate channels cascade;
truncate developers cascade;

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

insert into developers (
 id,
email,
username,
google_id,
twitter_handle
inserted_at,
updated_at,
) select
  ld.id,
  ld.email,
  ld.username,
  ld.username,
  ld.twitter_handle,
  ld.created_at,
  ld.updated_at
from legacy.developers ld;

select setval('developers_id_seq', (select max(id) from legacy.developers));

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
  tweeted_at,
  developer_id
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
  lp.created_at, -- default the tweeted at column to the time the post was created
  lp.developer_id
from legacy.posts as lp
where lp.published_at is not null;

select setval('posts_id_seq', (select max(id) from legacy.posts));
