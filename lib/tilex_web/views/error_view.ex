defmodule TilexWeb.ErrorView do
  use TilexWeb, :view
  import Phoenix.Controller, only: [put_view: 2, put_root_layout: 2]
  import Plug.Conn, only: [put_status: 2, halt: 1]

  def render_error_page(conn, status) do
    conn
    |> put_root_layout({TilexWeb.LayoutView, :error})
    |> put_status(status)
    |> put_view(__MODULE__)
    |> Phoenix.Controller.render("#{status}.html")
    |> halt()
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
