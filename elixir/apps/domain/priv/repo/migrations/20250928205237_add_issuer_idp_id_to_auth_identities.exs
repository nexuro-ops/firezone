defmodule Domain.Repo.Migrations.AddIssuerIdpIdToAuthIdentities do
  use Domain, :migration

  def change do
    alter table(:auth_identities) do
      add(:issuer, :text)
      add(:idp_id, :text)
    end

    create(
      index(:auth_identities, [:account_id, :issuer, :idp_id],
        unique: true,
        name: :auth_identities_account_issuer_idp_id_index,
        where: "deleted_at IS NULL AND issuer IS NOT NULL AND idp_id IS NOT NULL"
      )
    )

    create(
      constraint(:auth_identities, :issuer_idp_id_both_set_or_neither,
        check:
          "(issuer IS NOT NULL AND idp_id IS NOT NULL) OR (issuer IS NULL AND idp_id IS NULL)"
      )
    )
  end
end
