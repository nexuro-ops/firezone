defmodule Domain.Repo.Migrations.CreateAuthProvidersTable do
  use Domain, :migration

  def change do
    create(table(:auth_providers, primary_key: false)) do
      account(primary_key: true)
      add(:id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))

      add(:type, :string, null: false)
      add(:context, :string, null: false)
      add(:disabled_at, :utc_datetime_usec)

      subject_trail()
      timestamps()
    end

    create(
      index(:auth_providers, [:account_id, :type],
        unique: true,
        where: "type = 'email' OR type = 'userpass'"
      )
    )

    create(
      constraint(:auth_providers, :type_must_be_valid,
        check: "type IN ('email', 'userpass', 'google', 'okta', 'entra', 'oidc')"
      )
    )

    create(
      constraint(:auth_providers, :context_must_be_valid,
        check: "context IN ('clients_and_portal', 'clients_only', 'portal_only')"
      )
    )
  end
end
