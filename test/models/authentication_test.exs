defmodule Kickstart.AuthenticationTest do
  use Kickstart.ModelCase

  alias Kickstart.Authentication

  @valid_attrs %{provider: "some content", token: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Authentication.changeset(%Authentication{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Authentication.changeset(%Authentication{}, @invalid_attrs)
    refute changeset.valid?
  end
end
