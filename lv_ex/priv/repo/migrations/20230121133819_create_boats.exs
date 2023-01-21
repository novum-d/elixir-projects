defmodule LvEx.Repo.Migrations.CreateBoats do
  use Ecto.Migration

  def change do
    create table(:boats) do
      add :image, :string
      add :model, :string
      add :price, :string
      add :type, :string

      timestamps()
    end
  end
end
