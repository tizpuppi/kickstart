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
  alias Kickstart.User
  alias Kickstart.Repo

  def request(conn, _params, _current_user) do
    changeset = User.changeset(%User{})
    render(conn, "signin.html", callback_url: Helpers.callback_url(conn), changeset: changeset)
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

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params, _current_user) do
    case UserFromAuth.find_or_create(auth, Repo) do
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
