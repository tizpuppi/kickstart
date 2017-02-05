defmodule Kickstart.Repo.Migrations.CreateRegistrationToken do
  use Ecto.Migration

  def change do
    create table(:registration_tokens) do
      add :email, :string
      add :registration_token, :string

      timestamps(updated_at: false)
    end

    create unique_index(:registration_tokens, [:email])
    create index(:registration_tokens, [:registration_token])

  end
end
