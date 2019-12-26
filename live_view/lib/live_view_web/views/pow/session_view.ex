defmodule LiveViewWeb.Pow.SessionView do
  use LiveViewWeb, :view

  def mount(_session, socket) do
    {:ok, socket}
  end
end
