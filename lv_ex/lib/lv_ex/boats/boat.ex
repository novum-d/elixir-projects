defmodule LvEx.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boats" do
    field :model, :string
    field :price, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, [:model, :type, :price])
    |> validate_required([:model, :type, :price])
  end
end
