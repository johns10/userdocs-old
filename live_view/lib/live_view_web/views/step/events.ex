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
    parent_id = Helpers.get_id(data["parent-id"])
    parent_type = String.to_atom(Helpers.get_id(data["parent-type"]))
    assigns = Userdocs.Step.new(socket.assigns, parent_type, parent_id)
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
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.edit(socket.assigns, step_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::save", %{"step" => step}, socket) do
    Logger.debug("It saves this step to the state:")
    assigns = Userdocs.Step.save(socket.assigns, step)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::remove", data, socket) do
    Logger.debug("Removing step")
    id = Helpers.form_id(data)
    assigns = Userdocs.Step.remove(socket.assigns, :step, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::reorder_start", data, socket) do
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.reorder_start(
      socket.assigns, data, :drag)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("step::reorder_dragenter", data = %{"step-id" => ""}, socket) do
    Logger.debug("Invalid drag location")
    { :noreply, socket }
  end
  def handle_event("step::reorder_dragenter", data, socket) do
    Logger.debug("valid drag location")
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.reorder_drag(socket.assigns, data, step_id)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("step::reorder_end", form_data, socket) do
    Logger.debug("Reordering steps")
    data = socket.assigns.drag
    step_id = Helpers.get_id(data["step-id"])
    assigns = Userdocs.Step.reorder_end(socket.assigns, form_data, step_id)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("step::toggle_version_step_menu", data, socket) do
    assigns = Userdocs.Step.toggle_version_step_menu(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::cancel", data, socket) do
    Logger.debug("It cancels an edit on a step")
    id = Helpers.form_id(data)
    assigns = Userdocs.Step.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("step::validate", %{"step" => step_form}, socket) do
    Logger.debug("To Validate a Step")
    id = Helpers.form_id(step_form)
    assigns = Userdocs.Step.validate(socket.assigns, step_form, id)
    { :noreply, assign(socket, assigns)}
  end
end
