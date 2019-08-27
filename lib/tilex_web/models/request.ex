defmodule Tilex.Request do
  use TilexWeb, :model

  @type t :: module

  @primary_key false

  schema "requests" do
    field(:page, :string)
    field(:request_time, :utc_datetime)
  end
end
