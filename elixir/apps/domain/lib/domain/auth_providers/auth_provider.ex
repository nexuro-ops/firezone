defmodule Domain.AuthProviders.AuthProvider do
  use Domain, :schema

  @primary_key false
  schema "auth_providers" do
    belongs_to :account, Domain.Accounts.Account, primary_key: true
    field :id, :binary_id, primary_key: true, read_after_writes: true
    field :type, Ecto.Enum, values: ~w[email userpass google okta entra oidc]a

    field :context, Ecto.Enum,
      values: ~w[clients_and_portal clients_only portal_only]a,
      default: :clients_and_portal

    field :disabled_at, :utc_datetime_usec

    has_many :email_auth_providers, Domain.Email.AuthProvider,
      where: [type: :email],
      references: :id

    has_many :userpass_auth_providers, Domain.Userpass.AuthProvider,
      where: [type: :userpass],
      references: :id

    has_many :google_auth_providers, Domain.Google.AuthProvider,
      where: [type: :google],
      references: :id

    has_many :okta_auth_providers, Domain.Okta.AuthProvider, where: [type: :okta], references: :id

    has_many :entra_auth_providers, Domain.Entra.AuthProvider,
      where: [type: :entra],
      references: :id

    has_many :oidc_auth_providers, Domain.OIDC.AuthProvider, where: [type: :oidc], references: :id
  end
end
