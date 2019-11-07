defmodule LiveViewWeb.PageController do
  use LiveViewWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, LiveViewWeb.PagesView, session: %{})
  end
end
