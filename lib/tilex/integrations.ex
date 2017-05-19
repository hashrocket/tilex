defmodule Tilex.Integrations do
  @slack_notifier Application.get_env(:tilex, :slack_notifier)
  @twitter_notifier Application.get_env(:tilex, :twitter_notifier)

  def notify(conn, post = %Tilex.Post{}) do
    developer = Tilex.Repo.one(Ecto.assoc(post, :developer))
    channel = Tilex.Repo.one(Ecto.assoc(post, :channel))
    url = Tilex.Router.Helpers.post_url(conn, :show, post)

    @slack_notifier.notify(post, developer, channel, url)
    @twitter_notifier.notify(post, developer, channel, url)

    post_changeset = Ecto.Changeset.change(post, %{tweeted_at: Ecto.DateTime.utc})
    Tilex.Repo.update!(post_changeset)

    conn
  end

  def notify(conn, _) do
    conn
  end
end
