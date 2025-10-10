defmodule Domain.AuthProviders do
  alias Domain.{
    Accounts,
    Auth,
    AuthProviders,
    Repo
  }

  def create_auth_provider(attrs, %Auth.Subject{} = subject) do
    required_permission = AuthProviders.Authorizer.manage_auth_providers_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      AuthProviders.AuthProvider.Changeset.create(attrs, subject)
      |> Repo.insert()
    end
  end

  def fetch_auth_provider_by_id(%Accounts.Account{} = account, id) do
    AuthProviders.AuthProvider.Query.all()
    |> AuthProviders.AuthProvider.Query.by_account_id(account.id)
    |> AuthProviders.AuthProvider.Query.by_id(id)
    |> Repo.fetch(AuthProviders.AuthProvider.Query)
  end

  def delete_auth_provider(
        %AuthProviders.AuthProvider{} = auth_provider,
        %Auth.Subject{} = subject
      ) do
    required_permission = AuthProviders.Authorizer.manage_auth_providers_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      Repo.delete(auth_provider)
    end
  end

  def update_auth_provider(
        %AuthProviders.AuthProvider{} = auth_provider,
        attrs,
        %Auth.Subject{} = subject
      ) do
    required_permission = AuthProviders.Authorizer.manage_auth_providers_permission()

    with :ok <- Auth.ensure_has_permissions(subject, required_permission) do
      auth_provider
      |> AuthProviders.AuthProvider.Changeset.update(attrs)
      |> Repo.update()
    end
  end
end
