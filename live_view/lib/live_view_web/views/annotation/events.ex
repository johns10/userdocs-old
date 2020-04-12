defmodule LiveViewWeb.Annotation.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Page
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  alias Userdocs.Annotation

  def handle_event("annotation::expand", data, socket)  do
    Logger.debug("It expands or un-expands the annotation")
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Annotation.expand(socket.assigns, id)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("annotation::save", %{"annotation" => annotation}, socket) do
    Logger.debug("It saves this annotation to the state:")
    assigns = Userdocs.Annotation.save(socket.assigns, annotation)
    {:noreply, assign(socket, assigns)}
  end
"""

  def handle_event("annotate_page", data, socket) do
    #IO.puts("Creating Job")
    job = %{
      String.to_atom(data["type"]) => String.to_atom(data["id"]),
      job_type: :annotate,
      type: :job,
      status: :not_started
    }

    Helpers.create(job, UUID.uuid4(), :job)
    {:noreply, socket}
  end

  ######################### Annotation Wrappers ######################

  def handle_event("page_annotation_new", data, socket) do
    #IO.puts("New Annotation Event")
    id = Helpers.form_id(data)

    socket =
      Types.Annotation.new(socket, id)
      |> Types.Annotation.assign_new(id)
      |> Types.Page.toggle_new_form_mode(id, :new_annotation)

    {:noreply, socket}
  end

  def handle_event("annotation::expand", data, socket) do
    #IO.puts("Expand Annotation")ing
    id = Helpers.get_id(data["id"])
    socket = Annotation.expand(socket, id)
    {:noreply, socket}
  end
  """
  """
  def handle_event("annotation::validate", data, socket) do
    Logger.debug("To Validate an Annotation")
    Logger.debug("It extracts the steps from the form, and attaches their respective args")
    form = Map.get(data, "nil")

    submitted_steps =
      Enum.filter(
        form,
        fn {key, value} -> String.starts_with?(key, "step") end
      )
      |> Enum.map(fn {id, object} -> {String.replace(id, "step-", ""), object} end)
      |> Enum.map(fn {key, value} ->
        Map.put(value, "args", Helpers.parse_args(form, key))
      end)

    id = Helpers.get_id(form["id"])
    type_id = Helpers.get_id(form["annotation_type_id"])
    type = Helpers.get_one(socket.assigns, :annotation_type, type_id)
    object = Helpers.get_one(socket.assigns, :annotation, id)

    Logger.debug("It creates a new changeset from the form with these changes")
    original_changeset = Types.Annotation.changeset(socket.assigns, Map.from_struct(object))
    updated_changeset = Types.Annotation.changeset(socket.assigns, form)

    Logger.debug("It Gets the old changeset or the new one (if nil)")
    old_changeset = socket.assigns.changesets["annotation"][id]

    old_changeset =
      Types.Helpers.check_changeset(old_changeset, updated_changeset, original_changeset)

    Logger.debug(
      old_changeset.changes.annotation_type_id == updated_changeset.changes.annotation_type_id
    )
    changeset =
      %Storage.Annotation{}
      |> Storage.Annotation.form_changeset(annotation, %{
        pages: pages,
        annotation_types: annotation_types
      })
      |> Map.put(:action, :insert)

    {:noreply, socket}
  end
  """
  def handle_event("annotation::validate", %{"annotation" => form}, socket) do
    Logger.debug("To Validate an Annotation")
    id = Helpers.form_id(form)
    assigns = Userdocs.Annotation.validate(socket.assigns, form)
    { :noreply, assign(socket, assigns)}
  end
end
