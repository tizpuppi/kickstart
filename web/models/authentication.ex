defmodule Kickstart.Authentication do
  use Kickstart.Web, :model

  schema "authentications" do
    field :provider, :string
    field :uid, :string
    field :token, :string
    belongs_to :user, Kickstart.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:provider, :uid, :token, :user_id])
    |> validate_required([:provider, :uid, :token])
    |> cast_assoc(:user)
  end
end
