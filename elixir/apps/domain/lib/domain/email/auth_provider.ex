defmodule Domain.Email.AuthProvider do
  use Domain, :schema

  @primary_key false
  schema "email_auth_providers" do
    belongs_to :account, Domain.Accounts.Account, primary_key: true
    belongs_to :auth_provider, Domain.AuthProviders.AuthProvider, primary_key: true

    subject_trail(~w[actor identity system]a)
    timestamps()
  end
end
