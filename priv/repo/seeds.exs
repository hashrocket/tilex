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

Repo.insert!(%Channel{name: "business-wisdom", twitter_hashtag: "businesswisdom"})
Repo.insert!(%Channel{name: "command-line", twitter_hashtag: "command-line"})
Repo.insert!(%Channel{name: "computer-science", twitter_hashtag: "computerscience"})
Repo.insert!(%Channel{name: "devops", twitter_hashtag: "devops"})
Repo.insert!(%Channel{name: "elixir", twitter_hashtag: "myelixirstatus"})
Repo.insert!(%Channel{name: "emberjs", twitter_hashtag: "emberjs"})
Repo.insert!(%Channel{name: "git", twitter_hashtag: "git"})
Repo.insert!(%Channel{name: "html-css", twitter_hashtag: "frontendwebdev"})
Repo.insert!(%Channel{name: "javascript", twitter_hashtag: "javascript"})
phoenix_channel = Repo.insert!(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})
Repo.insert!(%Channel{name: "rails", twitter_hashtag: "rubyonrails"})
Repo.insert!(%Channel{name: "react", twitter_hashtag: "reactjs"})
Repo.insert!(%Channel{name: "ruby", twitter_hashtag: "ruby"})
Repo.insert!(%Channel{name: "sql", twitter_hashtag: "sql"})
Repo.insert!(%Channel{name: "svelte", twitter_hashtag: "svelte"})
Repo.insert!(%Channel{name: "vim", twitter_hashtag: "vim"})
Repo.insert!(%Channel{name: "workflow", twitter_hashtag: "workflow"})

developer = Repo.insert!(%Developer{email: "developer@ghed.dev", username: "10x"})

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
  channel: phoenix_channel,
  developer: developer,
  slug: Post.generate_slug()
})

Repo.insert!(%Post{
  title: "Testing Elixir",
  body: "A Rubyist's Journey",
  channel: phoenix_channel,
  developer: developer,
  slug: Post.generate_slug()
})
