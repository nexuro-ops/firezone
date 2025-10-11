defmodule Domain.Repo.Migrations.CreateUserpassAuthProviders do
  use Domain, :migration

  def change do
    create table(:userpass_auth_providers, primary_key: false) do
      account(primary_key: true)
      add(:auth_provider_id, :binary_id, null: false, primary_key: true)

      add(:context, :string, null: false)
      add(:disabled_at, :utc_datetime_usec)

      subject_trail()
      timestamps()
    end

    create(index(:userpass_auth_providers, [:account_id], unique: true))

    execute(
      """
      ALTER TABLE userpass_auth_providers
      ADD CONSTRAINT userpass_auth_providers_auth_provider_id_fkey
      FOREIGN KEY (account_id, auth_provider_id)
      REFERENCES auth_providers(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE userpass_auth_providers
      DROP CONSTRAINT userpass_auth_providers_auth_provider_id_fkey
      """
    )

    create(
      constraint(:userpass_auth_providers, :context_must_be_valid,
        check: "context IN ('clients_and_portal', 'clients_only', 'portal_only')"
      )
    )
  end
end
