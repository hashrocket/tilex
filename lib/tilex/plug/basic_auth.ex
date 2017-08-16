defmodule Tilex.Plug.BasicAuth do

  @moduledoc """
    Provides basic authentication for staging instances.
  """

  def init(default), do: default

  def call(conn, _default) do
    if Application.get_env(:tilex, :basic_auth) do
      BasicAuth.call(conn, BasicAuth.init([use_config: {:tilex, :basic_auth}]))
    else
      conn
    end
  end
end
