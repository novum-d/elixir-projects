defmodule LvExWeb.AutocompleteLive do
  use LvExWeb, :live_view

  alias LvEx.Stores
  alias LvEx.Cities

  def render(assigns) do
    ~H"""
    <h1>Find Store</h1>
    <div id="search">
      <form phx-submit="zip-search">
        <input
          type="text"
          name="zip"
          value={@zip}
          placefolder="Zip Code"
          autofocus
          autocomplete="off"
          readonly={@loading}
        />
        <button type="submit">
          <img src="images/search.svg" alt="search" />
        </button>
      </form>
      <form phx-submit="city-search" phx-change="suggest-city">
        <input
          type="text"
          name="city"
          value={@city}
          placefolder="City Code"
          autocomplete="nope"
          list="matches"
          phx-debounce="1000"
          readonly={@loading}
        />
        <button type="submit">
          <img src="images/search.svg" alt="search" />
        </button>
      </form>
      <datalist id="matches">
        <option :for={match <- @matches} value={match}><%= match %></option>
      </datalist>
      <div :if={@loading} class="loader">Loading...</div>
      <div class="stores">
        <ul>
          <li :for={store <- @stores}>
            <div class="first-line">
              <div class="name"><%= store.name %></div>
              <div class="status">
                <span :if={store.open} class="open"></span>
                <span :if={!store.open} class="closed"></span>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg" alt="location" />
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg" alt="phone" />
                  <%= store.phone_number %>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        zip: "",
        city: "",
        stores: [],
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    socket = assign(socket, zip: zip, stores: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("city-search", %{"city" => city}, socket) do
    send(self(), {:run_city_search, city})
    socket = assign(socket, city: city, stores: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    socket = assign(socket, matches: Cities.suggest(prefix))
    {:noreply, socket}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    socket =
      case Stores.search_by_zip(zip) do
        [] ->
          socket
          |> put_flash(:info, "No stores matching \"#{zip}\"")
          |> assign(stores: [], loading: false)

        stores ->
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)
      end

    {:noreply, socket}
  end

  def handle_info({:run_city_search, city}, socket) do
    socket =
      case Stores.search_by_city(city) do
        [] ->
          socket
          |> put_flash(:info, "No stores matching \"#{city}\"")
          |> assign(stores: [], loading: false)

        stores ->
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)
      end

    {:noreply, socket}
  end
end
