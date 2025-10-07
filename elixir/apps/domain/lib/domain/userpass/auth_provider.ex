defmodule Domain.Userpass.AuthProvider do
  use Domain, :schema

  @primary_key false
  schema "userpass_auth_providers" do
    belongs_to :account, Domain.Accounts.Account
    belongs_to :directory, Domain.Directories.Directory
    belongs_to :auth_provider, Domain.AuthProviders.AuthProvider, primary_key: true

    field :disabled_at, :utc_datetime_usec

    subject_trail(~w[actor identity system]a)
    timestamps()
  end
end
