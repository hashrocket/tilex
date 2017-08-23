defmodule Tilex.Integrations do
  @slack_notifier Application.get_env(:tilex, :slack_notifier)
  @twitter_notifier Application.get_env(:tilex, :twitter_notifier)

  alias Ecto.{Changeset, DateTime}
  alias Tilex.{Post, Repo}
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers

  def notify(conn, %Post{} = post) do
    developer = Repo.one(Ecto.assoc(post, :developer))
    channel = Repo.one(Ecto.assoc(post, :channel))
    url = Helpers.post_url(conn, :show, post)

    @slack_notifier.notify(post, developer, channel, url)
    @twitter_notifier.notify(post, developer, channel, url)

    post_changeset = Changeset.change(post, %{tweeted_at: DateTime.utc})
    Repo.update!(post_changeset)

    conn
  end

  def notify(conn, _), do: conn
  def notify_of_awards(%Post{max_likes: max_likes} = post, max_likes_changed) when rem(max_likes, 10) == 0 and max_likes_changed do
    developer = Repo.one(Ecto.assoc(post, :developer))
    url = Helpers.post_url(Endpoint, :show, post)

    @slack_notifier.notify_of_awards(post, developer, url)
  end
  def notify_of_awards(_, _), do: nil
end
