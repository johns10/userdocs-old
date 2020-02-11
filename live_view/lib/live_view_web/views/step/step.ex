defmodule LiveViewWeb.Step do
  use Phoenix.LiveView
  require Logger

  alias LiveViewWeb.Helpers

  def new_project_step_map(assigns, order \\ 0) do
    version_id = assigns.current_version_id

    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      order: order,
      args: %{},
      version: nil,
      version_id: version_id,
      annotation: nil,
      annotation_id: nil,
      step_type: nil,
      step_type_id: 1,
      page: nil,
      page_id: nil
    }
  end

  def new_page_step_map(assigns, page_id) do
    version_id = assigns.current_version_id

    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      order: 0,
      args: %{},
      version: nil,
      version_id: nil,
      annotation: nil,
      annotation_id: nil,
      step_type: nil,
      step_type_id: 1,
      page: nil,
      page_id: page_id
    }
  end

  def associations(assigns) do
    %{
      version: assigns.version,
      annotation: assigns.annotation,
      step_type: assigns.step_type,
      page: assigns.page
    }
  end

  def changeset({ socket = %Phoenix.LiveView.Socket{}, object }) do
    { socket, changeset(socket.assigns, object) }
  end
  def changeset(assigns, step) do
    Storage.Step.form_changeset(
      %Storage.Step{},
      step,
      associations(assigns)
    )
  end

  ############################# CRUD ###############################

end
