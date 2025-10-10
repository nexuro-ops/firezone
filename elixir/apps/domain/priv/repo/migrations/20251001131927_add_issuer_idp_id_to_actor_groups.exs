defmodule Domain.Repo.Migrations.AddIssuerIdpIdToActorGroups do
  use Domain, :migration

  def change do
    alter table(:actor_groups) do
      add(:issuer, :text)
      add(:idp_id, :text)
    end

    create(
      index(:actor_groups, [:account_id, :issuer, :idp_id],
        unique: true,
        where: "deleted_at IS NULL AND issuer IS NOT NULL AND idp_id IS NOT NULL"
      )
    )

    create(
      constraint(:actor_groups, :issuer_idp_id_both_set_or_neither,
        check:
          "(issuer IS NOT NULL AND idp_id IS NOT NULL) OR (issuer IS NULL AND idp_id IS NULL)"
      )
    )
  end
end
