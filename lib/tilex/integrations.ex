defmodule Tilex.Integrations do

  @moduledoc """
    Integrates Twitter and Slack into Tilex.
  """

  @slack_notifier Application.get_env(:tilex, :slack_notifier)
  @twitter_notifier Application.get_env(:tilex, :twitter_notifier)

  def notify(conn, post = %Tilex.Post{}) do
    developer = Tilex.Repo.one(Ecto.assoc(post, :developer))
    channel = Tilex.Repo.one(Ecto.assoc(post, :channel))
    url = TilexWeb.Router.Helpers.post_url(conn, :show, post)

    @slack_notifier.notify(post, developer, channel, url)
    @twitter_notifier.notify(post, developer, channel, url)

    post_changeset = Ecto.Changeset.change(post, %{tweeted_at: Ecto.DateTime.utc})
    Tilex.Repo.update!(post_changeset)

    conn
  end
  def notify(conn, _), do: conn

  def notify_of_awards(post = %Tilex.Post{max_likes: max_likes}, max_likes_changed) when rem(max_likes, 10) == 0 and max_likes_changed do
    developer = Tilex.Repo.one(Ecto.assoc(post, :developer))
    url = TilexWeb.Router.Helpers.post_url(TilexWeb.Endpoint, :show, post)

    @slack_notifier.notify_of_awards(post, developer, url)
  end
  def notify_of_awards(_, _), do: nil
end
