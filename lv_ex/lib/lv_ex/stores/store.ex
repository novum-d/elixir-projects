defmodule LvEx.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "store" do
    field :Hours, :string
    field :city, :string
    field :name, :string
    field :open, :boolean, default: false
    field :phone_number, :string
    field :street, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :street, :phone_number, :city, :zip, :open, :Hours])
    |> validate_required([:name, :street, :phone_number, :city, :zip, :open, :Hours])
  end
end
