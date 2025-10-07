defmodule Domain.Google.Directory.Changeset do
  use Domain, :changeset

  alias Domain.{
    Auth,
    Google.Directory
  }

  @required_fields ~w[name account_id hosted_domain created_by created_by_subject]a
  @create_fields @required_fields ++ ~w[jit_provisioning superadmin_email impersonation_email]a
  @update_fields ~w[superadmin_email superadmin_emailed_at impersonation_email jit_provisioning name
    hosted_domain error_count disabled_at disabled_reason synced_at error error_emailed_at]a

  def create(attrs, %Auth.Subject{} = subject) do
    %Directory{}
    |> cast(attrs, @create_fields)
    |> put_change(:account_id, subject.account.id)
    |> put_subject_trail(:created_by, subject)
    |> maybe_create_parent_directory(subject.account.id)
    |> changeset()
  end

  def update(%Directory{} = directory, attrs) do
    directory
    |> cast(attrs, @update_fields)
    |> changeset()
  end

  def changeset(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:hosted_domain, min: 1, max: 255)
    |> validate_number(:error_count, greater_than_or_equal_to: 0)
    |> validate_length(:error, max: 2_000)
    |> assoc_constraint(:account)
    |> assoc_constraint(:directory)
    |> unique_constraint([:account_id, :hosted_domain],
      message: "is already configured for this account and Google Workspace domain"
    )
  end

  defp maybe_create_parent_directory(changeset, account_id) do
    case {get_field(changeset, :directory_id), get_assoc(changeset, :directory)} do
      {nil, nil} ->
        changeset
        |> put_assoc(:directory, %Domain.Directories.Directory{
          account_id: account_id,
          type: :google
        })

      _directory_id ->
        changeset
    end
  end
end
