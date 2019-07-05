defmodule Tilex.Auth.ErrorHandlerTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Auth.ErrorHandler

  setup %{conn: conn} do
    new_conn =
      conn
      |> Plug.Test.init_test_session(%{})
      |> Phoenix.ConnTest.fetch_flash()

    [conn: new_conn]
  end

  describe "auth_error/3" do
    test "redirects to root with 302", %{conn: conn} do
      assert conn
             |> ErrorHandler.auth_error({:oauth_failure, :token_expired}, [])
             |> redirected_to(302) == "/"
    end

    test "adds a flash message with error", %{conn: conn} do
      assert conn
             |> ErrorHandler.auth_error({:oauth_failure, :token_expired}, [])
             |> Phoenix.ConnTest.get_flash() == %{"info" => "Authentication required"}
    end
  end
end
