defmodule Domain.OIDC.AuthProvider.Changeset do
  use Domain, :changeset

  alias Domain.{
    Auth,
    OIDC.AuthProvider
  }

  @required_fields ~w[name account_id auth_provider_id client_id client_secret
    discovery_document_uri created_by created_by_subject]a

  def create(attrs, %Auth.Subject{} = subject) do
    %AuthProvider{}
    |> cast(attrs, @required_fields)
    |> put_change(:account_id, subject.account.id)
    |> put_subject_trail(:created_by, subject)
    |> changeset()
  end

  def update(%AuthProvider{} = auth_provider, attrs) do
    auth_provider
    |> cast(
      attrs,
      ~w(name client_id client_secret discovery_document_uri disabled_at)a
    )
    |> changeset()
  end

  def changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:client_id, min: 1, max: 255)
    |> validate_length(:client_secret, min: 1, max: 255)
    |> validate_length(:discovery_document_uri, min: 1, max: 2_000)
    |> assoc_constraint(:account)
    |> assoc_constraint(:auth_provider)
    |> unique_constraint([:account_id, :client_id],
      message: "is already configured for this account and client ID"
    )
    |> unique_constraint([:account_id, :name],
      name: :oidc_auth_providers_account_id_name_index,
      message: "is already configured for this account with this name"
    )
  end
end
