defmodule Domain.Repo.Migrations.AddDirectoryIdToAuthIdentities do
  use Domain, :migration

  def change do
    alter table(:auth_identities) do
      add(:directory_id, :binary_id)
    end

    create(
      index(:auth_identities, [:account_id, :directory_id, :provider_identifier],
        unique: true,
        name: :auth_identities_account_directory_provider_identifier_index,
        where:
          "deleted_at IS NULL AND directory_id IS NOT NULL AND provider_identifier IS NOT NULL"
      )
    )

    create(
      index(:auth_identities, [:account_id, :directory_id, :email],
        unique: true,
        name: :auth_identities_account_directory_email_index,
        where: "deleted_at IS NULL AND directory_id IS NOT NULL AND provider_identifier IS NULL"
      )
    )

    up = """
    ALTER TABLE auth_identities
    ADD CONSTRAINT auth_identities_directory_id_fkey
    FOREIGN KEY (account_id, directory_id)
    REFERENCES directories(account_id, id)
    ON DELETE CASCADE
    """

    down = """
    ALTER TABLE auth_identities
    DROP CONSTRAINT auth_identities_directory_id_fkey
    """

    execute(up, down)
  end
end
