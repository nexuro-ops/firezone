defmodule Domain.Email.AuthProvider do
  use Domain, :schema

  @primary_key false
  schema "email_auth_providers" do
    belongs_to :account, Domain.Accounts.Account, primary_key: true
    belongs_to :auth_provider, Domain.AuthProviders.AuthProvider, primary_key: true

    field :context, Ecto.Enum,
      values: ~w[clients_and_portal clients_only portal_only]a,
      default: :clients_and_portal

    field :disabled_at, :utc_datetime_usec

    subject_trail(~w[actor identity system]a)
    timestamps()
  end
end
