defmodule LvEx.StoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvEx.Stores` context.
  """

  @doc """
  Generate a store.
  """
  def store_fixture(attrs \\ %{}) do
    {:ok, store} =
      attrs
      |> Enum.into(%{
        Hours: "some Hours",
        city: "some city",
        name: "some name",
        open: true,
        phone_number: "some phone_number",
        street: "some street",
        zip: "some zip"
      })
      |> LvEx.Stores.create_store()

    store
  end
end
