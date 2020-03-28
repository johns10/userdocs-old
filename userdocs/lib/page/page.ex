defmodule Userdocs.Page do

  require Logger

  alias Userdocs.Page.Constants
  alias Userdocs.Domain
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset

  def new(assigns, version_id) do
    page = Constants.new_map(assigns)
    Logger.debug("Fixing to put this in")
    changeset = Constants.changeset(assigns, page)
    page_struct = Kernel.struct(%Storage.Page{}, page)
    { assigns, pages } = StateHandlers.create(assigns, :page, page_struct)
    page = Enum.at(pages, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :page, page.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_version_pages, version_id], page.id)
      |> Kernel.put_in([:ui, :version_page_control, :mode], :new)

    Logger.debug("here's the new version pages changesets:")

    updated_page = Map.put(page, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, :page, updated_page)

    assigns
  end

  def edit(assigns, id) do
    changeset =
      Data.edit(assigns, :page, assigns.changesets.page[id], id)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :page, id], changeset)
      |> Kernel.put_in([:ui, :page_dropdown, :active], nil)
      |> Domain.expand(id, :page_edit)

  end

  def save(assigns, form) do
    assigns =
      Changeset.apply_changeset(assigns, :page, form)
      |> Changeset.handle_changeset_result(:page)
      |> Kernel.put_in([:ui, :version_page_control, :mode], :button)

  end

  def remove(assigns, type, id) do
    storage_status =
      assigns.changesets.page[id].changes.storage_status

    changesets = assigns.changesets.page

    assigns =
      Data.remove(:page, storage_status, id, assigns)
      |> Kernel.put_in([ :changesets, :page ], changesets)
      #|> Kernel.put_in([ :ui, :page_form, :toggled], false)

  end

  def cancel(assigns, id) do
    assigns =
      { assigns, Data.get_one(assigns, :page, id) }
      |> Helpers.to_map()
      |> Constants.changeset()
      |> Helpers.put_in_assigns([ :changesets, :page, id ])
      |> Domain.expand(id, :page_edit)
  end

  def validate(assigns, form, id) do
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :page, id], changeset)
  end

  """
  def toggle_dropdown(assigns) do
    status = not assigns.ui.version_menu.toggled
    Kernel.put_in(assigns, [:ui, :version_menu, :toggled], status)
  end

  def select(assigns, id) do
    assigns
    |> Kernel.put_in([:current_version_id], id)
    |> Kernel.put_in([:ui, :version_menu, :toggled], false)
  end

  def close_modal(assigns) do
    Kernel.put_in(assigns, [:ui, :version_form, :toggled], false)
  end
"""
  def expand(assigns, id) do
    Logger.debug("Expanding page in Userdocs")
    Logger.debug(id)
    assigns = Domain.expand(assigns, id, :active_pages)
  end

  def toggle_dropdown(assigns, id) do
    status = assigns.ui.page_dropdown.active
    Logger.debug(status)
    if status != nil do
      Kernel.put_in(assigns, [:ui, :page_dropdown, :active], nil)
    else
      Kernel.put_in(assigns, [:ui, :page_dropdown, :active], id)
    end
  end

  def expand_step_list(assigns, id) do
    Logger.debug("Expanding page step list in Userdocs")
    assigns
    |> Kernel.put_in([:ui, :page_step_form, id], Data.new_page_step_form())
    |> Domain.expand(id, :active_steps)
  end

  def expand_element_list(assigns, id) do
    Logger.debug("Expanding element list in Userdocs")
    assigns = Domain.expand(assigns, id, :active_page_elements)
  end

  def expand_annotation_list(assigns, id) do
    Logger.debug("Expanding element list in Userdocs")
    assigns = Domain.expand(assigns, id, :active_page_annotations)
  end
end
