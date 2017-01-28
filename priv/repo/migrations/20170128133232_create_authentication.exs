defmodule Kickstart.Repo.Migrations.CreateAuthentication do
  use Ecto.Migration

  def change do
    create table(:authentications) do
      add :provider, :string
      add :uid, :string
      add :token, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    
    create unique_index(:authentications, [:provider, :uid])
    create index(:authentications, [:user_id])

  end
end
