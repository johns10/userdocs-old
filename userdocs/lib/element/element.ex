defmodule Userdocs.Element do

  require Logger

  alias Userdocs.Element.Constants
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset
  alias Userdocs.Domain

  def new(assigns, page_id) do
    Logger.debug("Creating a new Element")
    page = Data.get_one(assigns, :page, page_id)

    element_map = Constants.new_map(assigns, page_id)

    { assigns, { :ok, new_element }, changeset } =
      Changeset.apply_changeset(assigns, :element, element_map)

    element_struct = Kernel.struct(Storage.Element, element_map)

    { assigns, result } = StateHandlers.create(assigns, :element, new_element)
    element = Enum.at(result, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :element, element.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_page_elements, page_id], element.id)
      |> Kernel.put_in([:ui, :page_element_forms, page_id], Data.new_page_element_form())

    updated_step = Map.put(element, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, :step, updated_step)
    assigns
  end

  def expand(assigns, id) do
    Logger.debug("Expanding element #{id} in Userdocs")
    assigns = Domain.expand(assigns, id, :active_elements)
    if id in assigns.active_elements do
      edit(assigns, id)
    else
      assigns
    end
  end

  def edit(assigns, id) do
    if assigns.changesets.element[id] == nil do
      Logger.debug("nil changeset")

      object = Data.get_one(assigns, :element, id)
      |> Map.from_struct()

      #I have to do this because of the parse args stuff
      changeset = Changeset.new(assigns, object, :element)
      changeset = Data.edit(assigns, :element, changeset, id)

      assigns
      |> Kernel.put_in([:changesets, :element, id], changeset)
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
        [ :ui, :page_element_forms, page_id, :mode ],
        :button
      )
    else
      assigns
    end
  end

  def remove(assigns, type, id) do
    storage_status = assigns.changesets.element[id].changes.storage_status
    changesets = assigns.changesets.element
    Data.remove(:element, storage_status, id, assigns)
    |> Kernel.put_in([ :changesets, :element ], changesets)
    |> Domain.expand(id, :active_elements)
  end

  def cancel(assigns, id) do
    step =
      assigns
      |> Data.get_one(:element, id)
      |> Map.from_struct()

    changeset =  Constants.changeset(assigns, step)
    assigns = Kernel.put_in(assigns, [ :changesets, :element, id ], changeset)
  end

  def validate(assigns, form) do
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :element, changeset.changes.id], changeset)
  end
  """

  def toggle_version_step_menu(assigns) do
    status = assigns.ui.project_steps_menu.toggled
    assigns = Kernel.put_in(assigns, [:ui, :project_steps_menu, :toggled], not status)
  end
  """
end
