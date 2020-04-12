defmodule Userdocs.Annotation do

  require Logger

  alias Userdocs.Annotation.Constants
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset
  alias Userdocs.Domain

  def new(assigns, parent_type, parent_id) do
    type = :annotation
    storage = Storage.Annotation
    parent = Data.get_one(assigns, parent_type, parent_id)
    parent_id_atom = String.to_atom(Atom.to_string(parent_type) <> "_id")

    map = Constants.new_map(assigns)

    { assigns, { :ok, object }, changeset } =
      Changeset.apply_changeset(assigns, type, map)

    struct = Kernel.struct(storage, map)
    { assigns, result } = StateHandlers.create(assigns, type, object)
    object = Enum.at(result, 0)

    current_changeset_atom =
      String.to_atom(
        "new_"
        <> Atom.to_string(parent_type)
        <> "_"
        <> Atom.to_string(type)
        <> "s"
      )


    assigns =
      assigns
      |> Kernel.put_in([:changesets, type, object.id], changeset)
      |> Kernel.put_in([:current_changesets, current_changeset_atom, parent_id], object.id)

    updated_object = Map.put(object, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, type, updated_object)
    assigns
  end

  def expand(assigns, id) do
    assigns = Domain.expand(assigns, id, :active_annotations)
    if id in assigns.active_annotations do
      edit(assigns, id)
    else
      assigns
    end
  end

  def edit(assigns, id) do
    if assigns.changesets.annotation[id] == nil do
      Logger.debug("nil changeset")

      object = Data.get_one(assigns, :annotation, id)
      |> Map.from_struct()

      #I have to do this because of the parse args stuff
      changeset = Changeset.new(assigns, object, :annotation)
      changeset = Data.edit(assigns, :annotation, changeset, id)

      assigns
      |> Kernel.put_in([:changesets, :annotation, id], changeset)
    else
      Logger.debug("not nil changeset")
      assigns
    end
  end

  def save(assigns, form) do
    #Logger.debug("Saving an Element")
    page_id = String.to_integer(Map.get(form, "page_id"))

    action = Data.object_action(form)

    assigns =
      Changeset.apply_changeset(assigns, :element, form)
      |> Changeset.handle_changeset_result(:element)

    if action == :insert do
      #Logger.debug("adding the button mode to the form")
      assigns = Kernel.put_in(assigns,
        [ :ui, :page_annotation_forms, page_id, :mode ],
        :button
      )
    else
      assigns
    end
  end
  """

  def remove(assigns, type, id) do
    storage_status = assigns.changesets.step[id].changes.storage_status
    changesets = assigns.changesets.step
    Data.remove(:step, storage_status, id, assigns)
    |> Kernel.put_in([ :changesets, :step ], changesets)
    |> Domain.expand(id, :active_steps)
  end

  def cancel(assigns, id) do
    step =
      assigns
      |> Data.get_one(:step, id)
      |> Data.parse_args()
      |> Map.from_struct()

    changeset =  Constants.changeset(assigns, step)
    assigns = Kernel.put_in(assigns, [ :changesets, :step, id ], changeset)
  end

  def reorder_start(assigns, data, key) do
    assigns = Map.put(assigns, key, data)
  end

  def reorder_drag(assigns, data, id) do
    Logger.debug("Reordering, drag event")
    data = assigns.drag
    target = Data.get_one(assigns, :step, id)
    source = Data.get_one(assigns, :step,
      String.to_integer(data["source-id"]))
    parent = Data.get_one(assigns,
      String.to_atom(data["parent-type"]),
      String.to_integer(data["parent-id"])
    )

    parent_id_atom = String.to_atom(data["parent-type"] <> "_id")

    { assigns, steps } = StateHandlers.get_related(
      assigns, parent_id_atom, [ parent ], :step)


    reordered_steps = Data.move(steps, source.order, target.order)

    Data.update_order_assigns(assigns, :step, reordered_steps)
  end

  def reorder_end(assigns, form_data, id) do
    Logger.debug("Reordering: end event")
    data = assigns.drag
    target = Data.get_one(assigns, :step, id)
    source = Data.get_one(assigns, :step,
      String.to_integer(data["source-id"]))
    parent = Data.get_one(assigns, :version,
      String.to_integer(data["parent-id"]))

    { assigns, steps } = StateHandlers.get_related(
      assigns, :version_id, [ parent ], :step)

    Data.update_order_state(assigns, :step, steps)
  end

  def toggle_version_step_menu(assigns) do
    status = assigns.ui.project_steps_menu.toggled
    assigns = Kernel.put_in(assigns, [:ui, :project_steps_menu, :toggled], not status)
  end
"""
  def validate(assigns, form) do
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :annotation, changeset.changes.id], changeset)
  end

end
