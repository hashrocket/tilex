defmodule Tilex.Auth.Guardian do
  use Guardian, otp_app: :tilex

  alias Tilex.{Developer, Repo}

  def subject_for_token(%Developer{} = developer, _claims), do: {:ok, "Developer:#{developer.id}"}
  def subject_for_token(_resource, _claims), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => "Developer:" <> id}), do: {:ok, Repo.get(Developer, id)}
  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end
