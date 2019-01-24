defmodule TilexWeb.StatsController do
  use TilexWeb, :controller

  alias Tilex.Stats

  alias Guardian.Plug, as: Guardian

  plug(
    Guardian.EnsureAuthenticated,
    [handler: __MODULE__]
    when action in ~w(admin)
  )

  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: stats_path(conn, :index))
  end

  def index(conn, _) do
    conn
    |> assign(:page_title, "Statistics")
    |> render("index.html", Stats.all())
  end

  def developer(conn, params) do
    conn
    |> assign(:page_title, "Admin Statistics")
    |> render("developer.html",
              params
              |> Map.get("filter")
              |> developer_params()
              |> Stats.developer())
  end

  defp developer_params(params) do
    %{
      start_date: date_param(params, "start_date", Timex.to_date({2008, 1, 1})),
      end_date: date_param(params, "end_date", Timex.today)
    }
  end

  defp date_param(nil, field, default), do: date_param(%{}, field, default)
  defp date_param(params, field, default) do
    case Map.get(params, field) do
      date when date in [nil, ""] -> default
      date -> Timex.parse!(date, "{YYYY}-{M}-{D}")
    end
  end

end
