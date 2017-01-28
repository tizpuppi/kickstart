defmodule Kickstart.UserFromAuth do

  alias Kickstart.User
  alias Kickstart.Authentication

  def find_or_create(auth, repo) do
    repo.transaction(fn -> create_user_from_auth(auth, repo) end)
  end

  defp create_user_from_auth(auth, repo) do
    name = name_from_auth(auth)
    result = User.changeset(%User{}, %{email: auth.info.email, username: name})
      |> repo.insert

    case result do
      {:ok, user} -> authorization_from_auth(user, auth, repo)
      {:error, reason} -> repo.rollback(reason)
    end

  end


  defp name_from_auth(auth) do
    if auth.info.nickname do
      auth.info.nickname
    else
      if auth.info.name do
        auth.info.name
      else
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and String.strip(&1) != ""))
        |> Enum.join(" ")
      end
    end
  end

  defp authorization_from_auth(user, auth, repo) do
    authentications = Ecto.build_assoc(user, :authentications)
    result = Authentication.changeset(authentications,
      %{
        provider: to_string(auth.provider),
        uid: auth.uid,
        token: to_string(auth.credentials.token)
      }
    ) |> repo.insert

    case result do
      {:ok, the_auth} -> the_auth
      {:error, reason} -> repo.rollback(reason)
    end
  end

end