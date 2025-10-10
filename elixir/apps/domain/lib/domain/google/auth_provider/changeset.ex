defmodule Domain.Google.AuthProvider.Changeset do
  use Domain, :changeset

  alias Domain.{
    Auth,
    AuthProviders,
    Google
  }

  @required_fields ~w[name account_id hosted_domain created_by created_by_subject]a
  @update_fields ~w[name hosted_domain]a

  def create(attrs, %Auth.Subject{} = subject) do
    %Google.AuthProvider{}
    |> cast(attrs, @required_fields)
    |> put_change(:account_id, subject.account.id)
    |> put_subject_trail(:created_by, subject)
    |> put_parent_assoc(attrs)
    |> changeset()
  end

  defp put_parent_assoc(changeset, %{"auth_provider" => %AuthProviders.AuthProvider{} = provider}) do
    put_assoc(changeset, :auth_provider, provider)
  end

  defp put_parent_assoc(changeset, %{auth_provider: %AuthProviders.AuthProvider{} = provider}) do
    put_assoc(changeset, :auth_provider, provider)
  end

  defp put_parent_assoc(changeset, _attrs) do
    add_error(changeset, :auth_provider, "must be specified")
  end

  def update(%Google.AuthProvider{} = auth_provider, attrs) do
    auth_provider
    |> cast(attrs, @update_fields)
    |> validate_required(:auth_provider_id)
    |> changeset()
  end

  def changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:hosted_domain, min: 1, max: 255)
    |> assoc_constraint(:account)
    |> assoc_constraint(:auth_provider)
    |> unique_constraint([:account_id, :hosted_domain],
      name: :google_auth_providers_pkey,
      message: "is already configured for this account and Google Workspace domain"
    )
    |> unique_constraint([:account_id, :name],
      name: :google_auth_providers_account_id_name_index,
      message: "is already configured for this account with this name"
    )
  end
end
