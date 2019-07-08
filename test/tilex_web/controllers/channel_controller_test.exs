defmodule TilexWeb.ChannelControllerTest do
  use TilexWeb.ConnCase

  alias Tilex.Channel
  alias Tilex.Factory

  describe "index" do
    setup ~w(authenticated_conn_setup)a

    test "lists all channels", %{conn: conn} do
      conn = get(conn, Routes.channel_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Channels"
    end
  end

  describe "new channel" do
    setup ~w(authenticated_conn_setup)a

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.channel_path(conn, :new))
      assert html_response(conn, 200) =~ "New Channel"
    end
  end

  describe "create channel" do
    setup ~w(authenticated_conn_setup)a

    test "redirects to index when data is valid", %{conn: conn} do
      attrs = Factory.attrs(Channel)
      conn = post(conn, Routes.channel_path(conn, :create), channel: attrs)
      assert redirected_to(conn) == Routes.channel_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.channel_path(conn, :create), channel: %{name: nil})
      assert html_response(conn, 200) =~ "New Channel"
    end
  end

  describe "edit channel" do
    setup ~w(authenticated_conn_setup)a

    test "renders form for editing chosen channel", %{conn: conn} do
      channel = Factory.insert!(Channel)
      conn = get(conn, Routes.channel_path(conn, :edit, channel))
      assert html_response(conn, 200) =~ "Edit Channel"
    end
  end

  describe "update channel" do
    setup ~w(authenticated_conn_setup)a

    test "redirects when data is valid", %{conn: conn} do
      channel = Factory.insert!(Channel)
      attrs = Factory.attrs(Channel)
      conn = put(conn, Routes.channel_path(conn, :update, channel), channel: attrs)
      assert redirected_to(conn) == Routes.channel_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      channel = Factory.insert!(Channel)
      conn = put(conn, Routes.channel_path(conn, :update, channel), channel: %{name: nil})
      assert html_response(conn, 200) =~ "Edit Channel"
    end
  end

  describe "delete channel" do
    setup ~w(authenticated_conn_setup)a

    test "deletes chosen channel", %{conn: conn} do
      channel = Factory.insert!(Channel)
      conn = delete(conn, Routes.channel_path(conn, :delete, channel))
      assert redirected_to(conn) == Routes.channel_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.channel_path(conn, :show, channel))
      end)
    end
  end

  defp authenticated_conn_setup(%{conn: conn}) do
    developer = Factory.insert!(:developer)
    [conn: Tilex.Auth.Guardian.Plug.sign_in(conn, developer, %{})]
  end
end
