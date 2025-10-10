defmodule Domain.Okta.AuthProvider do
  use Domain, :schema

  @primary_key false
  schema "okta_auth_providers" do
    belongs_to :account, Domain.Accounts.Account, primary_key: true
    belongs_to :auth_provider, Domain.AuthProviders.AuthProvider, primary_key: true

    field :name, :string
    field :org_domain, :string
    field :client_id, :string
    field :client_secret, :string

    subject_trail(~w[actor identity system]a)
    timestamps()
  end
end
