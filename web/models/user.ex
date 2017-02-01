defmodule Kickstart.User do
  use Kickstart.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :is_admin, :boolean
    field :password, :string, virtual: true

    has_many :authentications, Kickstart.Authentication

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
  end

  def social_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username])
  end
end
