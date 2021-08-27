defmodule Tilex.Plug.RequestRejectorTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Plug.RequestRejector

  @rejected_requests ~w[
    /xmlrpc.php
    /wp-login.php
  ]

  @successful_paths ~w[
    /posts/something
  ]

  describe "call/2" do
    for path <- @rejected_requests do
      @path path

      test "halts conn on bad request: '#{inspect(@path)}'" do
        conn =
          build_conn()
          |> Map.put(:request_path, @path)
          |> RequestRejector.call([])

        assert %Plug.Conn{halted: true, status: 404} = conn
      end
    end

    for path <- @successful_paths do
      @path path

      test "allows conn on ok request: '#{inspect(@path)}'" do
        conn =
          build_conn()
          |> Map.put(:request_path, @path)
          |> RequestRejector.call([])

        assert %Plug.Conn{halted: false, status: nil} = conn
      end
    end
  end
end
