defmodule Domain.Repo.Migrations.CreateOidcAuthProviders do
  use Domain, :migration

  def change do
    create table(:oidc_auth_providers, primary_key: false) do
      account(primary_key: true)
      add(:auth_provider_id, :binary_id, null: false, primary_key: true)

      add(:name, :string, null: false)
      add(:client_id, :string, null: false)
      add(:client_secret, :string, null: false)
      add(:discovery_document_uri, :text, null: false)

      subject_trail()
      timestamps()
    end

    create(index(:oidc_auth_providers, [:account_id, :client_id], unique: true))
    create(index(:oidc_auth_providers, [:account_id, :name], unique: true))

    execute(
      """
      ALTER TABLE oidc_auth_providers
      ADD CONSTRAINT oidc_auth_providers_auth_provider_id_fkey
      FOREIGN KEY (account_id, auth_provider_id)
      REFERENCES auth_providers(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE oidc_auth_providers
      DROP CONSTRAINT oidc_auth_providers_auth_provider_id_fkey
      """
    )
  end
end
