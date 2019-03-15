defmodule Tilex.Notifications do
  use GenServer

  alias Ecto.Changeset
  alias Tilex.{Post, Repo}
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers
  alias Tilex.Notifications.NotifiersSupervisor

  ### Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Alert the notification system that a new post has been created
  """
  def post_created(%Post{} = post) do
    GenServer.cast(__MODULE__, {:post_created, post})
  end

  def page_views_report(report) do
    GenServer.call(__MODULE__, {:page_views_report, report})
  end

  @doc """
  Alert the notification system that a post has been liked
  """
  def post_liked(%Post{} = post, max_likes_changed) do
    GenServer.cast(__MODULE__, {:post_liked, post, max_likes_changed})
  end

  ### Server API

  def init(_) do
    schedule_report()
    {:ok, :nostate}
  end

  def handle_info(:generate_page_views_report, :nostate) do
    schedule_report()

    with {:ok, report} <- Tilex.PageViewsReport.report() do
      notifiers()
      |> Enum.each(& &1.page_views_report(report))
    end

    {:noreply, :nostate}
  end

  def handle_cast({:post_created, %Post{} = post}, :nostate) do
    developer = Repo.one(Ecto.assoc(post, :developer))
    channel = Repo.one(Ecto.assoc(post, :channel))
    url = Helpers.post_url(Endpoint, :show, post)

    notifiers()
    |> Enum.each(& &1.post_created(post, developer, channel, url))

    post_changeset =
      post
      |> Changeset.change(%{tweeted_at: DateTime.truncate(DateTime.utc_now(), :second)})

    Repo.update!(post_changeset)

    {:noreply, :nostate}
  end

  def handle_cast({:post_liked, %Post{max_likes: max_likes} = post, max_likes_changed}, :nostate) do
    if rem(max_likes, 10) == 0 and max_likes_changed do
      developer = Repo.one(Ecto.assoc(post, :developer))
      url = Helpers.post_url(Endpoint, :show, post)

      notifiers()
      |> Enum.each(& &1.post_liked(post, developer, url))
    end

    {:noreply, :nostate}
  end

  def handle_call({:page_views_report, string_pid}, from, :nostate) do
    notifiers()
    |> Enum.each(& &1.page_views_report(string_pid))

    {:reply, from, true}
  end

  def notifiers(notifiers_supervisor \\ NotifiersSupervisor) do
    notifiers_supervisor.children()
  end

  defp schedule_report do
    timezone = parsed_time_zone()

    milliseconds_until_next_monday_nine_am =
      timezone
      |> Timex.now()
      |> Timex.shift(days: 7)
      |> Timex.beginning_of_week()
      |> Timex.shift(hours: 9)
      |> Timex.diff(
        Timex.now(timezone),
        :milliseconds
      )

    Process.send_after(
      __MODULE__,
      :generate_page_views_report,
      milliseconds_until_next_monday_nine_am
    )
  end

  defp parsed_time_zone do
    :tilex
    |> Application.get_env(:date_display_tz)
    |> Timex.Timezone.get()
    |> case do
      {:error, _error} ->
        raise(~s(
        There was an error parsing your time zone.
        Perhaps you forgot to set Environment Variable DATE_DISPLAY_TZ?
        ))

      zone ->
        zone
    end
  end
end
