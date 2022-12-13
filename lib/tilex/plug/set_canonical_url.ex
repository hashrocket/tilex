defmodule Tilex.Plug.SetCanonicalUrl do
  import Plug.Conn, only: [assign: 3]

  def init([]), do: []

  def call(%Plug.Conn{request_path: path} = conn, _default) do
    canonical_url =
      :tilex
      |> Application.get_env(:canonical_domain)
      |> URI.merge(path)
      |> URI.to_string()

    assign(conn, :canonical_url, canonical_url)
  end
end
