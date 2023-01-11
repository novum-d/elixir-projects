defmodule LvExWeb.SearchLive do
  use LvExWeb, :live_view

  alias LiveViewStudio.Stores

  def render(assigns) do
    ~H"""
    <h1></h1>
    <div id="search">
      <div class="stores">
        <ul>
          <li>
            <div class="first-line">
              <div class="name"></div>
              <div class="status">
                <span class="open"></span><span class="closed"></span>
              </div>
              <div class="second-line">
                <div class="street">
                  <img src="images/location.svg" alt="location" />
                </div>
                <div class="phone_number">
                  <img src="images/phone.svg" alt="phone" />
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    <section>
      <h1><b><%= @user.name %></b></h1>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        zip: "",
        stores: Stores.list_stores()
      )

    {:ok, socket}
  end
end
