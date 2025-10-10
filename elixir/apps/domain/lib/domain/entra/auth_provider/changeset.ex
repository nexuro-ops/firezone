defmodule Domain.Entra.AuthProvider.Changeset do
  use Domain, :changeset

  alias Domain.{
    Auth,
    Entra.AuthProvider
  }

  @required_fields ~w[name account_id auth_provider_id tenant_id created_by created_by_subject]a

  def create(attrs, %Auth.Subject{} = subject) do
    %AuthProvider{}
    |> cast(attrs, @required_fields)
    |> put_change(:account_id, subject.account.id)
    |> put_subject_trail(:created_by, subject)
    |> changeset()
  end

  def update(%AuthProvider{} = auth_provider, attrs) do
    auth_provider
    |> cast(attrs, ~w[name tenant_id]a)
    |> changeset()
  end

  def changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:tenant_id, min: 1, max: 255)
    |> assoc_constraint(:account)
    |> assoc_constraint(:auth_provider)
    |> unique_constraint([:account_id, :tenant_id],
      name: :entra_auth_providers_pkey,
      message: "is already configured for this account and Entra tenant"
    )
    |> unique_constraint([:account_id, :name],
      name: :entra_auth_providers_account_id_name_index,
      message: "is already configured for this account with this name"
    )
  end
end
