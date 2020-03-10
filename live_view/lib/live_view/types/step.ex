defmodule LiveViewWeb.Types.Step do
  use Phoenix.LiveView

  require Logger

  ############################ Constants ##########################



  def new_struct(assigns) do
    { args, step } = Map.pop(new_map(assigns), :args)
    args = Enum.map(args, fn({ index, arg }) -> Kernel.struct(Storage.Arg, arg) end)
    Kernel.struct(Storage.Step, step)
    |> Map.put(:args, args)
  end

  def new_map(assigns) do
    version_id = assigns.current_version_id

    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      order: 0,
      args: %{
        "0" => %{
          key:      "url",
          value:    " ",
        }
      },
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

  def changeset(assigns, step) do
    Storage.Step.form_changeset(
      %Storage.Step{},
      step,
      associations(assigns)
    )
  end

  ############################ CRUD ##########################

  def new(socket) do
    Logger.debug("New Step")
    LiveViewWeb.Types.Helpers.new(
      socket,
      new_map(socket.assigns),
      changeset(socket.assigns, new_map(socket.assigns))
    )
  end

  def edit(socket, data) do
    Logger.debug("Editing Step")
    Helpers.edit(
      data,
      socket,
      :step,
      Helpers.form_id(data),
      &changeset/2
    )
  end

  def save(object, socket) do
    Logger.debug("Saving Step")
    action = Helpers.object_action(object)

    Helpers.apply_changeset(
      %Storage.Step{},
      Storage.Step,
      object,
      associations(socket.assigns),
      Helpers.object_action(object)
    )
    |> Helpers.apply_state_change(:step, action)

    socket
  end

  def new_page_step(socket, id) do
    Logger.debug("New Page Step")
    LiveViewWeb.Types.Helpers.new(
      socket,
      new_page_step_map(socket.assigns, id),
      changeset(socket.assigns, new_page_step_map(socket.assigns, id))
    )
  end

  def assign_new_project_step({socket, changeset}, project_id) do
    Logger.debug("It assigns a new Project Step:")
    new_project_changesets =
      socket.assigns.changesets["new-project-steps"]
      |> Map.put(project_id, changeset)

    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:changesets, "new-project-steps"], new_project_changesets)

    assign(socket, assigns)
  end

  def assign_new_page_step({socket, object}, page_id) do
    Logger.debug("Assigning New Page Step")
    new_step_changesets =
      socket.assigns.changesets["new-page-step"]
      |> Map.put(page_id, object)

    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([ :changesets, "new-page-step" ], new_step_changesets)

    assign(socket, assigns)
  end

  ############################ UI ##########################

  def set_current(socket, id) do
    Logger.debug("Setting Current Step")
    id = Helpers.get_id(id)
    {assigns, objects} = StateHandlers.get(socket.assigns, :step, [id])
    object = Enum.at(objects, 0)
    socket = expand(socket, object.id)

    assign(socket, assigns)
  end

  def set_mode(socket, mode) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "project-step-form", "mode"], mode)

    assign(socket, assigns)
  end

  def toggle_form(socket, status) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "project-step-form", "toggled"], status)

    assign(socket, assigns)
  end

  def expand(socket, id) do
    Helpers.expand(socket, id, :active_steps)
  end

  def toggle_dropdown(socket, open) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "project-steps-menu", "toggled"], open)

    assign(socket, assigns)
  end
end
