defmodule TilexWeb.LayoutView do
  use TilexWeb, :view

  @request_tracking Application.get_env(:tilex, :request_tracking)

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
  def page_title(_), do: Application.get_env(:tilex, :organization_name)

  def twitter_image_url(%Tilex.Post{} = post) do
    channel_name = channel_name(post)

    case File.exists?("assets/static/assets/#{channel_name}_twitter_card.png") do
      true -> twitter_image_url(channel_name)
      false -> twitter_image_url(nil)
    end
  end

  def twitter_image_url(name) when is_binary(name) do
    TilexWeb.Endpoint.static_url() <> "/assets/#{name}_twitter_card.png"
  end

  def twitter_image_url(name) when is_nil(name) do
    TilexWeb.Endpoint.static_url() <> "/assets/til_twittercard.png"
  end

  defp channel_name(post) do
    case Ecto.assoc_loaded?(post.channel) do
      true -> String.replace(post.channel.name, "-", "_")
      false -> nil
    end
  end

  def twitter_title(%Tilex.Post{} = post) do
    Tilex.Post.twitter_title(post)
  end

  def twitter_title(_post) do
    "Today I Learned: a Hashrocket Project"
  end

  def twitter_description(%Tilex.Post{} = post) do
    markdown = Tilex.Post.twitter_description(post)

    earmark_options = %Earmark.Options{pure_links: false}

    with {:ok, html, _errors} <- Earmark.as_html(markdown, earmark_options),
         {:ok, fragment} <- Floki.parse_fragment(html) do
      Floki.text(fragment)
    else
      _error ->
        markdown
    end
  end

  def twitter_description(_post) do
    """
    TIL is an open-source project by Hashrocket that exists to catalogue the sharing & accumulation of knowledge as it happens day-to-day. Posts have a 200-word limit, and posting is open to any Rocketeer as well as select friends of the team. We hope you enjoy learning along with us.
    """
  end

  def request_tracking() do
    @request_tracking
  end
end
