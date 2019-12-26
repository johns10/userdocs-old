defmodule LiveViewWeb.PagesController do

  import Phoenix.LiveView.Controller
  use LiveViewWeb, :controller

  def index(conn, _) do
    conn
    |> Phoenix.LiveView.Controller.live_render(
      LiveViewWeb.PagesView,
      session: %{
        current_user: Pow.Plug.current_user(conn)
      })
  end
end
