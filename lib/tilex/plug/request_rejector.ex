defmodule Tilex.Plug.RequestRejector do
  @rejected_paths [
    ~r/\.php$/
  ]

  def init([]), do: []

  def call(%Plug.Conn{request_path: path} = conn, _default) do
    if Enum.any?(@rejected_paths, &match_rejected_path(path, &1)) do
      TilexWeb.ErrorView.render_error_page(conn, 404)
    else
      conn
    end
  end

  defp match_rejected_path(path, %Regex{} = regex) do
    Regex.match?(regex, path)
  end
end
