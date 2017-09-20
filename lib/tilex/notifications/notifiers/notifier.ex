defmodule Tilex.Notifications.Notifier do
  @moduledoc """
  Notifier implements callbacks for different system
  notifications.

  Implement your own notifier using this module and overriding
  the appropriate handlers.

  ## Example:
  defmodule Tilex.Notifications.Notifiers.Facebook do
    use Tilex.Notifications.Notifier

    def handle_post_created(post, developer, channel, url) do
      # send notification about created post to facebook
    end

    def handle_post_liked(post, developer, url) do
      # send notification about liked post to facebook
    end
  end

  Then add your new notifier to
  Tilex.Notifications.NotifiersSupervisor.children/1
  """

  alias Tilex.{Post, Developer, Channel}

  @callback handle_post_created(Post.t, Developer.t, Channel.t, url :: String.t) :: any
  @callback handle_post_liked(Post.t, Developer.t, url :: String.t) :: any

  defmacro __using__(_) do
    quote location: :keep do
      use GenServer
      @behaviour Tilex.Notifications.Notifier

      ## Client API

      def start_link(_) do
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
      end

      def post_created(post, developer, channel, url) do
        GenServer.cast(__MODULE__, {:post_created, post, developer, channel, url})
      end

      def post_liked(post, developer, url) do
        GenServer.cast(__MODULE__, {:post_liked, post, developer, url})
      end

      ### Server Callbacks

      def init(state) do
        {:ok, state}
      end

      def handle_cast({:post_created, post, developer, channel, url}, state) do
        handle_post_created(post, developer, channel, url)
        {:noreply, state}
      end

      def handle_cast({:post_liked, post, developer, url}, state) do
        handle_post_liked(post, developer, url)
        {:noreply, state}
      end
    end
  end
end
