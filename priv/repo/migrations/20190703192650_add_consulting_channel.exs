defmodule Tilex.Repo.Migrations.AddConsultingChannel do
  use Ecto.Migration

  def up do
    execute("""
      insert into channels (name, twitter_hashtag, inserted_at, updated_at)
        values ('consulting', 'consulting', now(), now());
    """)
  end

  def down do
    execute("""
      delete from channels where name = 'consulting';
    """)
  end
end
