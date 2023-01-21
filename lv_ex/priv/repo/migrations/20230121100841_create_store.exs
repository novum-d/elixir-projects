defmodule LvEx.Repo.Migrations.CreateStore do
  use Ecto.Migration

  def change do
    create table(:store) do
      add :name, :string
      add :street, :string
      add :phone_number, :string
      add :city, :string
      add :zip, :string
      add :open, :boolean, default: false, null: false
      add :Hours, :string

      timestamps()
    end
  end
end
