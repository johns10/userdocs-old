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
  """

  def expand(assigns, id) do
    assigns = Domain.expand(assigns, id, :active_steps)
    if id in assigns.active_steps do
      edit(assigns, id)
    else
      assigns
    end
  end

  def edit(assigns, id) do
    if assigns.changesets.step[id] == nil do
      Logger.debug("nil changeset")

      object = Data.get_one(assigns, :step, id)
      |> Data.parse_args()
      |> Map.from_struct()

      #I have to do this because of the parse args stuff
      changeset = Changeset.new(assigns, object, :step)
      changeset = Data.edit(assigns, :step, changeset, id)

      assigns
      |> Kernel.put_in([:changesets, :step, id], changeset)
    else
      Logger.debug("not nil changeset")
      assigns
    end
  end

  def save(assigns, form) do
    Changeset.apply_changeset(assigns, :step, form)
    |> Changeset.handle_changeset_result(:step)
    |> Kernel.put_in([ :ui, :version_step_form, :toggled ], false)
  end

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

  def validate(assigns, form, id) do
    step_id = id
    step_type_id = String.to_integer(form["step_type_id"])

    step_type = Data.get_one(assigns, :step_type, step_type_id)
    step_object =
      Data.get_one(assigns, :step, step_id)
      |> Data.parse_args()

    Logger.debug("If it can't find the original object, it returns the changeset from the form")
    #I have to do this because of the parse args stuff
    { assigns, result, original_changeset } =
      Changeset.apply_changeset(assigns, :step, form)
    original_changeset = Data.edit(assigns, :step, original_changeset, id)

    current_changeset = Changeset.new(assigns, form, :step)
    old_changeset = assigns.changesets.step[step_id]

    Logger.debug("If there's an old changeset, use it.  Otherwise, use the original changeset.")
    old_changeset =
      Changeset.check_old_changeset(old_changeset, original_changeset)

    old_step_type_id =
      try do
        old_changeset.changes.step_type_id
      rescue
        KeyError -> nil
        _ -> nil
      end
    new_step_type_id =
      try do
        current_changeset.changes.step_type_id
      rescue
        KeyError -> nil
        _ -> nil
      end

    updated_args =
      Changeset.check_type_change(
        old_step_type_id == new_step_type_id,
        form["args"],
        current_changeset.params["args"],
        step_type.args
      )

    updated_step_form = Map.put(form, "args", updated_args)

    Logger.debug("It updates the form with the new args")

    updated_changeset =
      %Storage.Step{}
      |> Storage.Step.form_changeset(updated_step_form, Constants.associations(assigns))
      |> Map.put(:action, :insert)

    Logger.debug("It creates a new changeset from the form and puts it on the assigns:")

    assigns = Kernel.put_in(assigns, [:changesets, :step, step_id], updated_changeset)
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :version, id], changeset)
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
end
