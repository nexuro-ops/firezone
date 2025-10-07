defmodule Domain.Repo.Migrations.CreateGoogleAuthProviders do
  use Domain, :migration

  def change do
    create table(:google_auth_providers, primary_key: false) do
      account()

      add(:auth_provider_id, :binary_id, null: false, primary_key: true)
      add(:directory_id, :binary_id, null: false)

      add(:name, :string, null: false)
      add(:hosted_domain, :string)
      add(:disabled_at, :utc_datetime_usec)

      subject_trail()
      timestamps()
    end

    create(index(:google_auth_providers, [:account_id, :hosted_domain], unique: true))
    create(index(:google_auth_providers, [:account_id, :name], unique: true))

    execute(
      """
      ALTER TABLE google_auth_providers
      ADD CONSTRAINT google_auth_providers_auth_provider_id_fkey
      FOREIGN KEY (account_id, auth_provider_id)
      REFERENCES auth_providers(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE google_auth_providers
      DROP CONSTRAINT google_auth_providers_auth_provider_id_fkey
      """
    )

    execute(
      """
      ALTER TABLE google_auth_providers
      ADD CONSTRAINT google_auth_providers_directory_id_fkey
      FOREIGN KEY (account_id, directory_id)
      REFERENCES directories(account_id, id)
      ON DELETE CASCADE
      """,
      """
      ALTER TABLE google_auth_providers
      DROP CONSTRAINT google_auth_providers_directory_id_fkey
      """
    )
  end
end
