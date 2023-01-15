defmodule LvExWeb.FlightLive do
  use LvExWeb, :live_view

  alias LvEx.Flights

  def render(assigns) do
    ~H"""
    <div id="search">
      <h1>Find a Flight</h1>
      <form phx-submit="search-flight">
        <input
          type="text"
          name="flight-num"
          value={@number}
          placefolder="Search Flight..."
          autofocus
          autocomplete="off"
          readonly={@loading}
        />
        <button type="submit">
          <img src="images/search.svg" alt="" />
        </button>
      </form>
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
    socket = assign(socket, number: "", flights: Flights.list_flights(), loading: false)
    {:ok, socket}
  end

  def handle_event("search-flight", %{"flight-num" => number}, socket) do
    send(self(), {:run_search_flight, number})
    socket = assign(socket, number: number, flights: [], loading: true)
    {:noreply, socket}
  end

  def handle_info({:run_search_flight, number}, socket) do
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

  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%m", :strftime)
  end
end
