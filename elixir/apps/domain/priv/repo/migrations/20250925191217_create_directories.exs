defmodule Domain.Repo.Migrations.CreateDirectories do
  use Domain, :migration

  def change do
    create table(:directories, primary_key: false) do
      account(primary_key: true)
      add(:id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:type, :string, null: false)
    end

    create(index(:directories, [:account_id, :type], unique: true, where: "type = 'firezone'"))

    create(
      constraint(:directories, :type_must_be_valid,
        check: "type IN ('okta', 'google', 'entra', 'firezone')"
      )
    )
  end
end
