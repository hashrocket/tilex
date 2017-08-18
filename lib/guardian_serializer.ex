defmodule Tilex.GuardianSerializer do

  @moduledoc """
    Provides functions for managing sessions with Guardian.
  """

  @behaviour Guardian.Serializer

  alias Tilex.{Developer, Repo}

  def for_token(developer = %Developer{}), do: { :ok, "Developer:#{developer.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("Developer:" <> id), do: { :ok, Repo.get(Developer, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
