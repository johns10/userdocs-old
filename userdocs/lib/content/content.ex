defmodule Userdocs.Content do

  require Logger

  alias Userdocs.Content.Constants
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset

  def new(assigns) do
    struct_type = %Storage.Content{}
    type = :content

    object = Constants.new_map(assigns)
    changeset = Constants.changeset(assigns, object)
    struct = Kernel.struct(struct_type, object)
    { assigns, objects } = StateHandlers.create(assigns, type, struct)
    object = Enum.at(objects, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, type, object.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_content], object.id)
      |> Kernel.put_in([:ui, :content_form, :mode], :new)

    updated_object = Map.put(object, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, type, updated_object)

    assigns
  end

  def edit(assigns, id) do
    type = :content

    changeset =
      Data.edit(assigns, type, assigns.changesets[type][id], id)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, type, id], changeset)

  end

  def save(assigns, form) do
    type = :content
    Logger.debug("Saving Content")
    id = String.to_integer(form["id"])
    object = Userdocs.Data.get_one(assigns, :content, id)
    Logger.debug(object.storage_status)

    assigns =
      Changeset.apply_changeset(assigns, type, form)
      |> Changeset.handle_changeset_result(type)

    if object.storage_status == "web" do
      assigns
      |> Kernel.put_in([ :ui, :content_form, :mode ], :button)
      |> Kernel.put_in([ :current_changesets, :new_content], nil)
    else
      assigns
    end

  end

  def remove(assigns, type, id) do
    Logger.debug("removing a content")
    type = :content
    changesets = assigns.changesets[type]
    object = Userdocs.Data.get_one(assigns, :content, id)

    storage_status = object.storage_status

    assigns =
      Data.remove(type, storage_status, id, assigns)
      |> Kernel.put_in([ :changesets, type ], changesets)
      |> Kernel.put_in([ :ui, :content_form, :toggled], false)
      |> Userdocs.Domain.expand(id, :active_content)

  end

  def cancel(assigns, id) do
    type = :content

    assigns =
      { assigns, Data.get_one(assigns, type, id) }
      |> Helpers.to_map()
      |> Constants.changeset()
      |> Helpers.put_in_assigns([ :changesets, type, id ])
  end

  def validate(assigns, form, id) do
    type = :content
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, type, id], changeset)
  end

  def menu_toggle(assigns) do
    status = not assigns.ui.content_menu.toggled
    Logger.debug(status)
    Kernel.put_in(assigns, [:ui, :content_menu, :toggled], status)
  end


  def close_modal(assigns) do
    Kernel.put_in(assigns, [:ui, :content_menu, :toggled], false)
  end

  def expand(assigns, id) do
    assigns = Userdocs.Domain.expand(assigns, id, :active_content)
    if id in assigns.active_content do
      edit(assigns, id)
    else
      assigns
    end
  end
end
