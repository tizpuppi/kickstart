defmodule Kickstart.RegistrationToken do
  use Kickstart.Web, :model

  schema "registration_tokens" do
    field :email, :string
    field :registration_token, :string

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  alias Kickstart.Repo

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :registration_token])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:registration_token)
  end

  def registration_token(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> generate_registration_token()
  end

  def valid?(token) do
    true
  end

  defp generate_registration_token(struct) do
    token = SecureRandom.hex(30)

    case Repo.get_by(__MODULE__, registration_token: token) do
      nil ->
        put_change(struct, :registration_token, token)
      _ ->
        generate_registration_token(struct)
    end
  end
end
