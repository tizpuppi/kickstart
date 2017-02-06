defmodule Kickstart.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use Kickstart.Web, :controller
  plug Ueberauth

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn,
                                          conn.params,
                                          Guardian.Plug.current_resource(conn)])
  end

  alias Ueberauth.Strategy.Helpers
  alias Kickstart.UserFromAuth
  alias Kickstart.RegistrationToken
  alias Kickstart.User
  alias Kickstart.Repo
  alias Kickstart.Email
  alias Kickstart.Mailer

  def request(conn, _params, _current_user) do
    changeset = User.registration_changeset(%User{})
    render(conn, "signin.html", callback_url: Helpers.callback_url(conn), changeset: changeset)
  end

  def register(conn, _params, _current_user) do
    changeset = RegistrationToken.registration_token(%RegistrationToken{})
    render(conn, "registration.html", changeset: changeset)
  end

  def confirm(conn, %{"registration_token" => registration_param}, _current_user) do
    email = String.downcase(registration_param["email"])
    case Repo.get_by(RegistrationToken, email: email) do
      nil -> nil
      registration -> Repo.delete!(registration)
    end
    changeset = RegistrationToken.registration_token(%RegistrationToken{}, registration_param)

    case Repo.insert(changeset) do
      {:ok, registration} ->
        Email.registration_email(registration.email, registration.registration_token)
          |> Mailer.deliver_now

        render(conn, "create.html", email: registration.email)
      {:error, changeset} ->
        render(conn, "registration.html", changeset: changeset)
    end
  end

  def confirm_token(conn, %{"token" => token}, _current_user) do
    token? =
      case Repo.get_by(RegistrationToken, registration_token: token) do
        nil -> nil
        token ->
          if RegistrationToken.valid?(token) do
            token
          else
            nil
          end
       end

    if token? do
      Repo.delete!(token?)
      changeset = User.registration_changeset(%User{email: token?.email})
      render(conn, "confirm.html", changeset: changeset)
    else
      conn
      |> put_flash(:error, "Not valid.")
      |> redirect(to: "/")
    end
  end

  def delete(conn, _params, _current_user) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user) do
    case UserFromAuth.find_or_create(auth, Repo, current_user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params, _current_user) do
  case UserFromAuth.validate_password(auth, Repo) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/")
    {:error, reason} ->
      conn
      |> put_flash(:error, reason)
      |> redirect(to: "/")
    end
  end

end
