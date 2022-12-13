defmodule Tilex.Plug.SetCanonicalUrlTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Plug.SetCanonicalUrl

  @base Application.compile_env(:tilex, :canonical_domain)

  @urls [
    {"/", %{}, "#{@base}/"},
    {"/", %{"foo" => "bar"}, "#{@base}/"},
    {"/123-some-post", %{}, "#{@base}/123-some-post"},
    {"/123-some-post", %{"foo" => "bar"}, "#{@base}/123-some-post"}
  ]

  describe "call/2" do
    for {path, query, canonical} <- @urls do
      @path path
      @query query
      @canonical canonical

      test "sets canonical url for: '#{@path}' with '#{inspect(@query)}'" do
        conn =
          :get
          |> build_conn(@path, @query)
          |> SetCanonicalUrl.call([])

        assert conn.assigns.canonical_url == @canonical
      end
    end
  end
end
