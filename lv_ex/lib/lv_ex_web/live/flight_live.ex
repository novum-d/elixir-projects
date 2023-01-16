defmodule LvExWeb.FlightLive do
  use LvExWeb, :live_view

  alias LvEx.Flights
  alias LvEx.Airports

  def render(assigns) do
    ~H"""
    <div id="search">
      <h1>Find a Flight</h1>
      <form phx-submit="flight-search">
        <input
          type="text"
          name="flight-num"
          value={@number}
          placefolder="Search Flight..."
          autofocus
          autocomplete="nope"
          readonly={@loading}
        />
        <button type="submit">
          <img src="images/search.svg" alt="" />
        </button>
      </form>
      <form phx-submit="airport-search" phx-change="suggest-airport">
        <input
          type="text"
          name="airport"
          value={@airport}
          placefolder="Search Airport..."
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
      <div class="flights">
        <ul>
          <li :for={flight <- @flights}>
            <div class="first-line">
              <div class="number">
                Flight #<%= flight.number %>
              </div>
              <div class="origin-destination">
                <img src="images/location.svg" />
                <%= flight.origin %> to <%= flight.destination %>
              </div>
            </div>
            <div class="second-line">
              <div class="departs">
                Departs: <%= format_time(flight.departure_time) %>
              </div>
              <div class="arrives">
                Arrives: <%= format_time(flight.arrival_time) %>
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
      assign(socket,
        number: "",
        flights: Flights.list_flights(),
        airport: "",
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def handle_event("flight-search", %{"flight-num" => number}, socket) do
    send(self(), {:run_flight_search, number})
    socket = assign(socket, number: number, flights: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("suggest-airport", %{"airport" => prefix}, socket) do
    socket = assign(socket, matches: Airports.suggest(prefix))
    {:noreply, socket}
  end

  def handle_event("airport-search", %{"airport" => airport}, socket) do
    send(self(), {:run_airport_search, airport})
    socket = assign(socket, airport: airport, matches: [], loading: true)
    {:noreply, socket}
  end

  def handle_info({:run_flight_search, number}, socket) do
    socket =
      case Flights.search_by_number(number) do
        [] ->
          socket
          |> put_flash(:info, "Flight is not found.")
          |> assign(flights: [], loading: false)

        flights ->
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)
      end

    {:noreply, socket}
  end

  def handle_info({:run_airport_search, airport}, socket) do
    socket =
      case Flights.search_by_airport(airport) do
        [] ->
          socket
          |> put_flash(:info, "Airport is not found.")
          |> assign(flights: [], loading: false)

        flights ->
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)
      end

    {:noreply, socket}
  end

  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%m", :strftime)
  end
end
