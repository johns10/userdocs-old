defmodule Userdocs.Step do

  require Logger

  alias Userdocs.Step.Constants
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset
  alias Userdocs.Domain

  def new(assigns, step_id) do
    step = Data.get_one(assigns, :step, step_id)
    order = Data.max_order(assigns, :version_id, step, :step)

    step_map = Constants.new_project_step_map(assigns, order)

    { assigns, { :ok, new_step }, changeset } =
      Changeset.apply_changeset(assigns, :step, step_map)

    step_struct = Kernel.struct(Storage.Step, step_map)
    { assigns, result } = StateHandlers.create(assigns, :step, new_step)
    step = Enum.at(result, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :step, step.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_version_steps, step.version_id], step.id)
      |> Kernel.put_in([:ui, :project_step_form, :mode], :new)
      |> Kernel.put_in([:ui, :project_step_form, :toggled], true)

    updated_step = Map.put(step, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, :step, updated_step)
    assigns
  end

  def expand(assigns, id) do
    assigns = Domain.expand(assigns, id, :active_steps)
    if id in assigns.active_steps do
      edit(assigns, id)
    else
      Logger.debug(inspect(assigns.changesets["step"]))
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
    step_id = String.to_integer(form["id"])
    Changeset.apply_changeset(assigns, :step, form)
    |> Changeset.handle_changeset_result(:step)
    |> Kernel.put_in([ :ui, :project_step_form, :toggled ], false)
  end

  def remove(assigns, type, id) do
    storage_status = assigns.changesets.step[id].changes.storage_status
    changesets = assigns.changesets.step
    Data.remove(:step, storage_status, id, assigns)
    |> Kernel.put_in([ :changesets, :step ], changesets)
    |> Domain.expand(id, :active_steps)
  end

  def cancel(assigns, id) do
    { assigns, Data.get_one(assigns, :step, id) }
    |> Helpers.to_map()
    |> Constants.changeset()
    |> Helpers.put_in_assigns([ :changesets, :step, id ])
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
    Logger.debug(inspect(old_changeset))
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

    Logger.debug("It creates a new changeset from the form and puts it on the socket:")

    assigns = Kernel.put_in(assigns, [:changesets, :step, step_id], updated_changeset)
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :version, id], changeset)
  end

  def reorder_start(assigns, data, key) do
    assigns = Data.reorder_start(assigns, data, key)
  end

  def reorder_drag(assigns, data, id) do
    Data.reorder_drag(assigns, data, id)
  end

end
