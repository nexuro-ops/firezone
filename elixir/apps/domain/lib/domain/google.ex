defmodule Domain.Google do
  alias Domain.{
    Accounts,
    Auth,
    Google,
    Repo
  }

  def all_enabled_directories_for_account!(%Accounts.Account{} = account) do
    Google.Directory.Query.not_disabled()
    |> Google.Directory.Query.by_account_id(account.id)
    |> Repo.all()
  end

  def all_enabled_auth_providers_for_account!(%Accounts.Account{} = account) do
    Google.AuthProvider.Query.not_disabled()
    |> Google.AuthProvider.Query.by_account_id(account.id)
    |> Repo.all()
  end

  def create_auth_provider(attrs, %Auth.Subject{} = subject) do
    required_permission = Google.Authorizer.manage_auth_providers_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      Google.AuthProvider.Changeset.create(attrs, subject)
      |> Repo.insert()
    end
  end

  def create_directory(attrs, %Auth.Subject{} = subject) do
    required_permission = Google.Authorizer.manage_directories_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      Google.Directory.Changeset.create(attrs, subject)
      |> Repo.insert()
    end
  end

  def fetch_directory_by_directory_id(%Accounts.Account{} = account, directory_id) do
    Google.Directory.Query.all()
    |> Google.Directory.Query.by_account_id(account.id)
    |> Google.Directory.Query.by_directory_id(directory_id)
    |> Repo.fetch(Google.Directory.Query)
  end

  def fetch_auth_provider_by_auth_provider_id(
        %Accounts.Account{} = account,
        auth_provider_id
      ) do
    Google.AuthProvider.Query.not_disabled()
    |> Google.AuthProvider.Query.by_account_id(account.id)
    |> Google.AuthProvider.Query.by_auth_provider_id(auth_provider_id)
    |> Repo.fetch(Google.AuthProvider.Query)
  end

  def update_auth_provider(
        %Google.AuthProvider{} = auth_provider,
        attrs,
        %Auth.Subject{} = subject
      ) do
    required_permission = Google.Authorizer.manage_auth_providers_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      Google.AuthProvider.Query.all()
      |> Google.AuthProvider.Query.by_account_id(subject.account.id)
      |> Google.AuthProvider.Query.by_auth_provider_id(auth_provider.auth_provider_id)
      |> Repo.fetch_and_update(Google.AuthProvider.Query,
        with: &Google.AuthProvider.Changeset.update(&1, attrs)
      )
    end
  end

  def update_directory(%Google.Directory{} = directory, attrs, %Auth.Subject{} = subject) do
    required_permission = Google.Authorizer.manage_directories_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      Google.Directory.Query.all()
      |> Google.Directory.Query.by_account_id(subject.account.id)
      |> Google.Directory.Query.by_directory_id(directory.directory_id)
      |> Repo.fetch_and_update(Google.Directory.Query,
        with: &Google.Directory.Changeset.update(&1, attrs)
      )
    end
  end
end
