defmodule TilexWeb.LayoutView do
  use TilexWeb, :view
  import TilexWeb.Endpoint, only: [static_url: 0]
  import Phoenix.Component, only: [live_flash: 2]
  import TilexWeb.StructuredDataView, only: [to_ld_json: 1, organization_ld: 0]
  alias Tilex.Blog.Post

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def ga_identifier do
    Application.get_env(:tilex, :ga_identifier)
  end

  def imgur_api_key(conn) do
    current_user(conn) && Application.get_env(:tilex, :imgur_client_id)
  end

  def editor_preference(conn) do
    user = current_user(conn)
    user && user.editor
  end

  def page_title(%{post: post}), do: post.title
  def page_title(%{channel: channel}), do: String.capitalize(channel.name)
  def page_title(%{developer: developer}), do: developer.username
  def page_title(%{page_title: page_title}), do: page_title
  def page_title(%{conn: %{status: 404}}), do: "Not Found"
  def page_title(%{conn: %{status: s}}) when is_integer(s) and s > 400, do: "Server Error"
  def page_title(_), do: Application.get_env(:tilex, :organization_name)

  @images_folder "priv/static/images"
  @external_resource @images_folder

  @twitter_card_files Path.wildcard("#{@images_folder}/*_twitter_card.png")
  for file <- @twitter_card_files, do: @external_resource(file)
  @twitter_cards Enum.map(@twitter_card_files, &Path.basename/1)

  @default_twitter_card "til_twitter_card.png"
  @external_resource @default_twitter_card

  def twitter_image_url(%Post{} = p), do: twitter_image_url("#{channel_name(p)}_twitter_card.png")
  def twitter_image_url(card) when card in @twitter_cards, do: static_url() <> "/images/#{card}"
  def twitter_image_url(_card), do: static_url() <> "/images/#{@default_twitter_card}"

  defp channel_name(post) do
    case Ecto.assoc_loaded?(post.channel) do
      true -> String.replace(post.channel.name, "-", "_")
      false -> nil
    end
  end

  def twitter_title(%Post{title: title}), do: "Today I Learned: " <> title
  def twitter_title(_post), do: "Today I Learned: a Hashrocket Project"

  def twitter_description(%Post{body: body}) do
    body |> String.split("\n") |> hd |> Tilex.Markdown.to_content()
  end

  def twitter_description(_post) do
    """
    TIL is an open-source project by Hashrocket that exists to catalogue the sharing & accumulation of knowledge as it happens day-to-day. Posts have a #{Post.body_max_words()}-word limit, and posting is open to any Rocketeer as well as select friends of the team. We hope you enjoy learning along with us.
    """
  end

  def request_tracking(), do: Application.get_env(:tilex, :request_tracking)
end
