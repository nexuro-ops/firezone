defmodule Domain.Identities do
  alias Domain.{
    Accounts,
    Actors,
    Directories.Directory,
    Auth.Identity,
    Repo
  }

  def fetch_identity_for_sign_in(
        %Accounts.Account{} = account,
        directory_id,
        claims
      ) do
    with %Directory{} = directory <-
           Repo.get_by(Directory, account_id: account.id, id: directory_id) do
      fetch_identity_by_directory(account, directory, claims)
    else
      nil -> {:error, :not_found}
    end
  end

  def fetch_identity_by_directory(
        %Accounts.Account{} = account,
        %Directory{type: :google} = directory,
        %{"sub" => provider_identifier}
      ) do
    Identity.Query.not_deleted()
    |> Identity.Query.by_account_id(account.id)
    |> Identity.Query.by_directory_id(directory.id)
    |> Identity.Query.by_provider_identifier(provider_identifier)
    |> Repo.fetch(Identity.Query, preload: :actor)
  end

  def fetch_identity_by_directory(
        %Accounts.Account{} = account,
        %Directory{type: :entra} = directory,
        %{"oid" => provider_identifier}
      ) do
    Identity.Query.not_deleted()
    |> Identity.Query.by_account_id(account.id)
    |> Identity.Query.by_directory_id(directory.id)
    |> Identity.Query.by_provider_identifier(provider_identifier)
    |> Repo.fetch(Identity.Query, preload: :actor)
  end

  def fetch_identity_by_directory(
        %Accounts.Account{} = account,
        %Directory{type: :okta} = directory,
        %{"sub" => provider_identifier}
      ) do
    Identity.Query.not_deleted()
    |> Identity.Query.by_account_id(account.id)
    |> Identity.Query.by_directory_id(directory.id)
    |> Identity.Query.by_provider_identifier(provider_identifier)
    |> Repo.fetch(Identity.Query, preload: :actor)
  end

  def fetch_identity_by_directory(
        %Accounts.Account{} = account,
        %Directory{type: :firezone} = directory,
        %{"email" => provider_identifier}
      ) do
    Identity.Query.not_deleted()
    |> Identity.Query.by_account_id(account.id)
    |> Identity.Query.by_directory_id(directory.id)
    |> Identity.Query.by_provider_identifier(provider_identifier)
    |> Repo.fetch(Identity.Query, preload: :actor)
  end

  def create_identity_for_directory(
        %Actors.Actor{} = actor,
        %Directory{type: :google} = directory,
        claims
      ) do
    attrs = %{
      provider_identifier: claims["sub"],
      email: claims["email"]
    }

    Identity.Changeset.create_identity(actor, directory, attrs)
    |> Repo.insert()
  end

  def create_identity_for_directory(
        %Actors.Actor{} = actor,
        %Directory{type: :entra} = directory,
        claims
      ) do
    attrs = %{
      provider_identifier: claims["oid"],
      email: claims["email"]
    }

    Identity.Changeset.create_identity(actor, directory, attrs)
    |> Repo.insert()
  end

  def create_identity_for_directory(
        %Actors.Actor{} = actor,
        %Directory{type: :okta} = directory,
        claims
      ) do
    attrs = %{
      provider_identifier: claims["sub"],
      email: claims["email"]
    }

    Identity.Changeset.create_identity(actor, directory, attrs)
    |> Repo.insert()
  end

  def create_identity_for_directory(
        %Actors.Actor{} = actor,
        %Directory{type: :firezone} = directory,
        claims
      ) do
    attrs = %{
      provider_identifier: claims["email"],
      email: claims["email"]
    }

    Identity.Changeset.create_identity(actor, directory, attrs)
    |> Repo.insert()
  end
end
