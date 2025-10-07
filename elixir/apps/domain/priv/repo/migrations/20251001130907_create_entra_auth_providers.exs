defmodule Domain.Repo.Migrations.CreateEntraAuthProviders do
  use Domain, :migration

  def change do
    create table(:entra_auth_providers, primary_key: false) do
      account()

      add(:auth_provider_id, :binary_id, null: false, primary_key: true)
      add(:directory_id, :binary_id, null: false)

      add(:name, :string, null: false)
      add(:tenant_id, :string, null: false)
      add(:disabled_at, :utc_datetime_usec)

      subject_trail()
      timestamps()
    end

    create(index(:entra_auth_providers, [:account_id, :tenant_id], unique: true))
    create(index(:entra_auth_providers, [:account_id, :name], unique: true))

    execute(
      """
      ALTER TABLE entra_auth_providers
      ADD CONSTRAINT entra_auth_providers_auth_provider_id_fkey
      FOREIGN KEY (account_id, auth_provider_id)
      REFERENCES auth_providers(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE entra_auth_providers
      DROP CONSTRAINT entra_auth_providers_auth_provider_id_fkey
      """
    )

    execute(
      """
      ALTER TABLE entra_auth_providers
      ADD CONSTRAINT entra_auth_providers_directory_id_fkey
      FOREIGN KEY (account_id, directory_id)
      REFERENCES directories(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE entra_auth_providers
      DROP CONSTRAINT entra_auth_providers_directory_id_fkey
      """
    )
  end
end
