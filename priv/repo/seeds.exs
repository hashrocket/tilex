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

alias Tilex.Post
alias Tilex.Repo

Repo.delete_all(Post)

Repo.insert!(%Post{title: "Observing Change", body: "A Gold Master Test in Practice"})
Repo.insert!(%Post{title: "Controlling Your Test Environment", body: "Slow browser integration tests are a hard problem"})
Repo.insert!(%Post{title: "Testing Elixir", body: "A Rubyist's Journey"})
