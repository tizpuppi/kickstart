defmodule Kickstart.UserFromAuth do

  alias Kickstart.User
  alias Kickstart.Authentication

  def find_or_create(auth, repo) do
    # If user has logged in with the same provider in the past, load registered user
    case get_auth(auth, repo) do
      {:error, :not_found} -> repo.transaction(fn -> create_user_from_auth(auth, repo) end)
      {:ok, user} -> {:ok, user}
    end
  end

  def validate_password(auth, repo) do
    stored_auth = repo.get_by(Authentication, uid: auth.uid, provider: to_string(auth.provider))
    authentication = repo.preload(stored_auth, :user)

    cond do
      stored_auth && Comeonin.Bcrypt.checkpw(auth.credentials.other.password, authentication.token) ->
        {:ok, repo.get!(User, authentication.user_id)}
      stored_auth ->
        {:error, "wrong password"}
      true ->
         Comeonin.Bcrypt.dummy_checkpw()
         {:error, "user not found"}
    end
  end

  defp get_auth(auth, repo) do
    case repo.get_by(Authentication, uid: auth.uid, provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      authentication ->
        authentication = repo.preload(authentication, :user)
        {:ok, repo.get!(User, authentication.user_id)}
    end
  end

  defp create_user_from_auth(auth, repo) do

    name = name_from_auth(auth)
    user_changeset = User.social_changeset(%User{}, %{email: auth.info.email, username: name})
    auth_changeset = Authentication.changeset(%Authentication{},
                                              %{provider: to_string(auth.provider),
                                                uid: auth.uid,
                                                token: Comeonin.Bcrypt.hashpwsalt(to_string(auth.credentials.token))})
    user_with_auth = Ecto.Changeset.put_assoc(user_changeset, :authentications, [auth_changeset])

    repo.insert(user_with_auth)
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

end
