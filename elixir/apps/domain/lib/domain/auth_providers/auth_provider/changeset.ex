defmodule Domain.AuthProviders.AuthProvider.Changeset do
  use Domain, :changeset

  alias Domain.AuthProviders.AuthProvider

  @required_fields ~w[account_id type context created_by created_by_subject]a
  @update_fields ~w[context disabled_at]a

  def update(%AuthProvider{} = auth_provider, attrs) do
    auth_provider
    |> cast(attrs, @update_fields)
    |> changeset()
  end

  defp changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> assoc_constraint(:account)
    |> unique_constraint([:account_id, :type],
      name: :auth_providers_account_id_type_index,
      message: "is already configured for this account with this type"
    )
    |> check_constraint(:type, name: :type_must_be_valid, message: "is not a valid type")
    |> check_constraint(:context, name: :context_must_be_valid, message: "is not a valid context")
  end
end
