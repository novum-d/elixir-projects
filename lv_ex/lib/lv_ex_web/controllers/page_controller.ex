defmodule LvExWeb.PageController do
  use LvExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
