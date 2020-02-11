defmodule LiveViewWeb.Page.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Page
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("page::new", data, socket) do
    Logger.debug("It creates a new changeset for this page and puts on state")
    page_id = Helpers.get_id(data["page-id"])

    socket =
      Data.new_struct(socket, "page")
      |> Data.assign_new_object("page")
      |> Changeset.new("page")
      |> Changeset.assign_changeset("page")
      |> Changeset.assign_new_changeset_id([
        :current_changesets,
        "new-version-pages",
        page_id
      ])
      |> Helpers.socket_only()
      |> Page.set_mode(:new)
      |> Helpers.expand(page_id, :active_pages)

    {:noreply, socket}
  end

  def handle_event("page::edit", data, socket) do
    Logger.debug("It creates a changeset for the page, and puts it on the socket")
    Logger.debug(inspect(data))
    page_id = Helpers.get_id(data["page-id"])
    version_id = Helpers.get_id(data["version-id"])
    current_changeset = socket.assigns.changesets["page"][page_id]

    socket =
      Data.edit(socket, data, "page", current_changeset, page_id)
      |> Changeset.assign_changeset("page")
      |> Helpers.socket_only()
      |> Page.set_mode(:edit)
      |> Helpers.put_in_socket([:ui, "page-menu", "toggled"], false)
      |> Helpers.put_in_socket([:ui, "page-form", "toggled"], true)

    {:noreply, socket}
  end

  def handle_event("page::save", %{"page" => page}, socket) do
    Logger.debug("It saves this page to the state:")

    socket =
      Changeset.apply_changeset(page, "page", socket)
      |> Changeset.handle_changeset_result("page")
      |> Helpers.socket_only()
      |> Page.set_current(Helpers.form_id(page))

    {:noreply, socket}
  end

  def handle_event("page::remove", data, socket) do
    Logger.debug("Removing page")
    id = Helpers.form_id(data)

    socket =
      Helpers.set_removed({socket, id}, :page)
      |> Changeset.apply_changeset("page")
      |> Changeset.handle_changeset_result("page")
      |> Helpers.socket_only()

    {:noreply, socket}
  end

  def handle_event("page::cancel", data, socket) do
    Logger.debug("It cancels an edit on a page")

    id = Helpers.form_id(data)

    socket =
      Helpers.get_one({ socket, :page, id })
      |> Helpers.to_map()
      |> Page.changeset()
      |> Helpers.put_in_socket([:changesets, "page", id])

    {:noreply, socket}
  end

  def handle_event("page::validate", %{"page" => page}, socket) do
    Logger.debug("Validating page")
    id = Helpers.get_id(page["id"])

    socket =
      {socket, Page.changeset(socket.assigns, page)}
      |> Changeset.assign_changeset("page")
      |> Helpers.socket_only()

    {:noreply, socket}
  end

  def handle_event("page::expand", data, socket) do
    id = Helpers.get_id(data["id"])
    socket = Helpers.expand(socket, id, :active_pages)
    {:noreply, socket}
  end

  def handle_event("page::select", data = %{"id" => id}, socket) do
    socket =
      Page.set_current(socket, id)
      |> Helpers.put_in_socket([:ui, "page-menu", "toggled"], false)

    {:noreply, socket}
  end

  def handle_event("page::close_modal", data, socket) do
    socket = Helpers.put_in_socket(socket, [:ui, "page-form", "toggled"], false)
    {:noreply, socket}
  end
end
