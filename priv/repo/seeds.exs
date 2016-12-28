# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tilex.Repo.insert!(%Tilex.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tilex.Channel
alias Tilex.Post
alias Tilex.Repo

Repo.delete_all(Post)
Repo.delete_all(Channel)

phoenix_channel = Repo.insert!(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})
elixir_channel = Repo.insert!(%Channel{name: "elixir", twitter_hashtag: "myelixirstatus"})
erlang_channel = Repo.insert!(%Channel{name: "erlang", twitter_hashtag: "erlang"})

Repo.insert!(%Post{
  title: "Observing Change",
  body: "A Gold Master Test in Practice",
  channel_id: phoenix_channel.id,
})

Repo.insert!(%Post{
  title: "Controlling Your Test Environment",
  body: "Slow browser integration tests are a hard problem",
  channel_id: elixir_channel.id,
})

Repo.insert!(%Post{
  title: "Testing Elixir",
  body: "A Rubyist's Journey",
  channel_id: erlang_channel.id,
})
