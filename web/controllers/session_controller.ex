defmodule Kickstart.SessionController do
  use Kickstart.Web, :controller

  def new(conn, _params) do
    render conn, "signin.html"
  end

  def crate(conn, _params) do
    redirect(conn, to: "/")
  end

  def delete(conn, _params) do
    redirect(conn, to: "/")
  end
end

