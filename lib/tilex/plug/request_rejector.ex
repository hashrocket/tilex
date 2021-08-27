defmodule Tilex.Plug.RequestRejector do
  import Plug.Conn, only: [put_status: 2, halt: 1]
  import Phoenix.Controller, only: [put_view: 2, render: 2]

  @rejected_paths [
    ~r/\.php$/
  ]

  def init([]), do: []

  def call(%Plug.Conn{request_path: path} = conn, _default) do
    if Enum.any?(@rejected_paths, &match_rejected_path(path, &1)) do
      conn
      |> put_status(:not_found)
      |> put_view(TilexWeb.ErrorView)
      |> render("404.html")
      |> halt()
    else
      conn
    end
  end

  defp match_rejected_path(path, %Regex{} = regex) do
    Regex.match?(regex, path)
  end
end
