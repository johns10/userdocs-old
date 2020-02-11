defmodule Userdocs.Version do

  require Logger

  alias Userdocs.Version.Constants
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset

  def new(assigns, project_id) do
    version = Constants.new_map(assigns)
    changeset = Constants.changeset(assigns, version)
    version_struct = Kernel.struct(%Storage.Version{}, version)
    { assigns, versions } = StateHandlers.create(assigns, :version, version_struct)
    version = Enum.at(versions, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :version, version.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_project_versions, project_id], version.id)
      |> Kernel.put_in([:ui, :version_form, :mode], :new)
      |> Kernel.put_in([:ui, :version_menu, :toggled], false)
      |> Kernel.put_in([:ui, :version_form, :toggled], true)

    updated_version = Map.put(version, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, :version, updated_version)

    assigns
  end

  def edit(assigns, id) do
    changeset =
      Data.edit(assigns, :version, assigns.changesets.version[id], id)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :version, id], changeset)
      |> Kernel.put_in([:ui, :version_form, :mode], :edit)
      |> Kernel.put_in([:ui, :version_menu, :toggled], false)
      |> Kernel.put_in([:ui, :version_form, :toggled], true)

  end

  def save(assigns, form) do
    version_id = String.to_integer(form["id"])

    assigns =
      Changeset.apply_changeset(assigns, :version, form)
      |> Changeset.handle_changeset_result(:version)
      |> Kernel.put_in([ :current_version_id ], version_id)
      |> Kernel.put_in([ :ui, :version_form, :toggled ], false)

  end

  def remove(assigns, type, id) do
    storage_status =
      assigns.changesets.version[id].changes.storage_status

    changesets = assigns.changesets.version
    Logger.debug(inspect(changesets))

    assigns =
      Data.remove(:version, storage_status, id, assigns)
      |> Kernel.put_in([ :changesets, :version ], changesets)
      |> Kernel.put_in([ :ui, :version_form, :toggled], false)

  end

  def cancel(assigns, id) do
    assigns =
      { assigns, Data.get_one(assigns, :version, id) }
      |> Helpers.to_map()
      |> Constants.changeset()
      |> Helpers.put_in_assigns([ :changesets, :version, id ])
  end

  def validate(assigns, form, id) do
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :version, id], changeset)
  end

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

end
