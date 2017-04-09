defmodule Tilex.Slack do
  def post_notification(conn, post) do
    endpoint = System.get_env("slack_post_endpoint")

    developer = Tilex.Repo.one(Ecto.assoc(post, :developer))
    url = Tilex.Router.Helpers.post_url(conn, :show, post)
    text = "#{developer.username} created a new post <#{url}|#{post.title}>"

    spawn(
      fn ->
        HTTPoison.post("https://hooks.slack.com" <> endpoint, "{\"text\": \"#{text}\"}")
      end
    )
  end
end
