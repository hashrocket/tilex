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

alias Tilex.{Channel, Developer, Post, Repo}

Repo.delete_all(Post)
Repo.delete_all(Channel)
Repo.delete_all(Developer)

phoenix_channel = Repo.insert!(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})
elixir_channel = Repo.insert!(%Channel{name: "elixir", twitter_hashtag: "myelixirstatus"})
erlang_channel = Repo.insert!(%Channel{name: "erlang", twitter_hashtag: "erlang"})

developer= Repo.insert!(%Developer{email: "developer@hashrocket.com",
  username: "rickyrocketeer",
  google_id: "186823978541230597895"
})

1..100
  |> Enum.each(fn(_i) ->

  Repo.insert!(%Post{
    title: "Observing Change",
    body: "A Gold Master Test in Practice",
    channel: phoenix_channel,
    developer: developer,
    slug: Post.generate_slug()
  })

  Repo.insert!(%Post{
    title: "Controlling Your Test Environment",
    body: "Slow browser integration tests are a hard problem",
    channel: elixir_channel,
    developer: developer,
    slug: Post.generate_slug()
  })

  Repo.insert!(%Post{
    title: "Testing Elixir",
    body: "A Rubyist's Journey",
    channel: erlang_channel,
    developer: developer,
    slug: Post.generate_slug()
  })

end)
