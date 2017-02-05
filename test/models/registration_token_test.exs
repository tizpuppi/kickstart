defmodule Kickstart.RegistrationTokenTest do
  use Kickstart.ModelCase

  alias Kickstart.RegistrationToken

  @valid_attrs %{email: "some@example.com", registration_token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RegistrationToken.changeset(%RegistrationToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RegistrationToken.changeset(%RegistrationToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
