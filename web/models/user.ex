defmodule Kickstart.User do
  use Kickstart.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :is_admin, :boolean
    field :password, :string

    has_many :authentications, Kickstart.Authentication

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username])
  end
end
