defmodule Tilex.Plug.FormatInjector do
  import Phoenix.Controller, only: [put_format: 2]

  def init(default), do: default

  def call(%{params: %{"titled_slug" => slug}} = conn, _) do
    ext = Path.extname(slug)
    format = String.trim_leading(ext, ".")
    format = if format == "", do: "html", else: format

    conn
    |> put_format(format)
  end

  def call(conn, _), do: conn
end
