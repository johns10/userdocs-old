defmodule LiveViewWeb.Step.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Step
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("step::new", data, socket) do
    Logger.debug("It gets the version, the step, and the order")
    step_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Step.new(socket.assigns, step_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::expand", data, socket)  do
    Logger.debug("It expands or un-expands the project step")
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.expand(socket.assigns, step_id)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("step::edit", data, socket) do
    Logger.debug("It creates a changeset for the step, and puts it on the socket")
    Logger.debug(inspect(data))
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.edit(socket.assigns, step_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::save", %{"step" => step}, socket) do
    Logger.debug("It saves this step to the state:")
    Logger.debug(inspect(step))
    assigns = Userdocs.Step.save(socket.assigns, step)
    {:noreply, socket}
  end

  def handle_event("step::remove", data, socket) do
    Logger.debug("Removing step")
    id = Helpers.form_id(data)
    assigns = Userdocs.Step.remove(socket.assigns, :step, id)
    {:noreply, socket}
  end

  def handle_event("step::reorder_start", data, socket) do
    Logger.debug(inspect(data))
    assigns = Userdocs.Step.reorder_start(assigns, form_data, step_id)
    { :noreply, socket }
  end

  def handle_event("step::reorder_dragenter", data = %{"step-id" => ""}, socket) do
    Logger.debug("Invalid drag location")
    { :noreply, socket }
  end
  def handle_event("step::reorder_dragenter", form_data, socket) do
    Logger.debug("valid drag location")
    Logger.debug(inspect(form_data))
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.reorder_drag(assigns, form_data, step_id)
    { :noreply, socket }
  end

  def handle_event("step::reorder_end", form_data, socket) do
    Logger.debug("Reordering steps")
    step_id = Helpers.get_id(data["step-id"])
    data = socket.assigns.drag

    target = Helpers.get_one(socket.assigns, :step,
      Helpers.get_id(form_data["step-id"]))
    source = Helpers.get_one(socket.assigns, :step,
      Helpers.get_id(data["source-id"]))
    parent = Helpers.get_one(socket.assigns, :version,
      Helpers.get_id(data["parent-id"]))

    { assigns, steps } = StateHandlers.get_related(
      socket.assigns, :version_id, [ parent ], :step)

    reordered_steps = Helpers.move(steps, source.order, target.order)

    {:noreply, socket}
  end

  def handle_event("step::toggle_version_step_menu", data, socket) do
    status = socket.assigns.ui["project-steps-menu"]["toggled"]
    socket = Helpers.put_in_socket(socket,
      [:ui, "project-steps-menu", "toggled"], not status)

    {:noreply, socket}
  end

  def handle_event("step::cancel", data, socket) do
    Logger.debug("It cancels an edit on a step")

    id = Helpers.form_id(data)

    socket =
      Helpers.get_one({ socket, :step, id })
      |> Data.parse_args()
      |> Helpers.to_map()
      |> Changeset.new("step")
      |> Changeset.assign_changeset("step")
      |> Helpers.socket_only()

    {:noreply, socket}
  end

  def handle_event("step::toggle", data, socket) do
    status = not socket.assigns.ui["project-steps-menu"]["toggled"]
    socket = Helpers.put_in_socket(socket, [:ui, "project-steps-menu", "toggled"], status)
    {:noreply, socket}
  end

  def handle_event("step::select", data = %{"id" => id}, socket) do
    socket =
      Version.set_current(socket, id)
      |> Helpers.put_in_socket([:ui, "project-steps-menu", "toggled"], false)

    {:noreply, socket}
  end

  def handle_event("step::close_modal", data, socket) do
    socket = Helpers.put_in_socket(socket, [:ui, "project-steps-form", "toggled"], false)
    {:noreply, socket}
  end


  def handle_event("step::validate", %{"step" => step_form}, socket) do
    Logger.debug("To Validate a Step")
    id = Helpers.form_id(step_form)
    assigns = Userdocs.Step.validate(socket.assigns, step_form, id)
    { :noreply, socket }
  end
end
