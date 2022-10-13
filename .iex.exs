import_file_if_available("~/.iex.exs")

alias Tilex.Blog.Channel
alias Tilex.Blog.Developer
alias Tilex.Liking
alias Tilex.Blog.Post
alias Tilex.Rep

# Allow developer to reload IEx session with `R.reload!`.
defmodule R do
  def reload! do
    Mix.Task.reenable("compile.elixir")
    Application.stop(Mix.Project.config()[:app])
    Mix.Task.run("compile.elixir")
    Application.start(Mix.Project.config()[:app], :permanent)
  end
end
