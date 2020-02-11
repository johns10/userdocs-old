defmodule Userdocs.Project do

  require Logger

  alias Userdocs.Project.Constants
  alias Userdocs.Project.Domain
  alias Userdocs.Helpers
  alias Userdocs.Data
  alias Userdocs.Changeset

  def new(assigns) do
    project = Constants.new_map(assigns)
    changeset = Constants.changeset(assigns, project)
    project_struct = Kernel.struct(%Storage.Project{}, project)
    { assigns, projects } = StateHandlers.create(assigns, :project, project_struct)
    project = Enum.at(projects, 0)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :project, project.id], changeset)
      |> Kernel.put_in([:current_changesets, :new_project], project.id)
      |> Kernel.put_in([:ui, :project_form, :mode], :new)
      |> Kernel.put_in([:ui, :project_menu, :toggled], false)
      |> Kernel.put_in([:ui, :project_form, :toggled], true)

    updated_project = Map.put(project, :record_status, "existing")
    { assigns, result } = StateHandlers.update(assigns, :project, updated_project)

    assigns
  end

  def edit(assigns, id) do
    changeset =
      Data.edit(assigns, :project, assigns.changesets.project[id], id)

    assigns =
      assigns
      |> Kernel.put_in([:changesets, :project, id], changeset)
      |> Kernel.put_in([:ui, :project_form, :mode], :edit)
      |> Kernel.put_in([:ui, :project_menu, :toggled], false)
      |> Kernel.put_in([:ui, :project_form, :toggled], true)

  end

  def save(assigns, form) do
    project_id = String.to_integer(form["id"])

    assigns =
      Changeset.apply_changeset(assigns, :project, form)
      |> Changeset.handle_changeset_result(:project)
      |> Domain.set_current_project(project_id)
      |> Domain.set_default_project_version(project_id)
      |> Kernel.put_in([:ui, :project_form, :toggled], false)

  end

  def remove(assigns, type, id) do
    Logger.debug("removing a project")
    storage_status =
      assigns.changesets.project[id].changes.storage_status

    changesets = assigns.changesets.project

    assigns =
      Data.remove(:project, storage_status, id, assigns)
      |> Kernel.put_in([ :changesets, :project ], changesets)
      |> Kernel.put_in([ :ui, :project_form, :toggled], false)

  end

  def cancel(assigns, id) do
    assigns =
      { assigns, Data.get_one(assigns, :project, id) }
      |> Helpers.to_map()
      |> Constants.changeset()
      |> Helpers.put_in_assigns([ :changesets, :project, id ])
  end

  def validate(assigns, form, id) do
    changeset = Constants.changeset(assigns, form)
    Kernel.put_in(assigns, [:changesets, :project, id], changeset)
  end

  def toggle_dropdown(assigns) do
    status = not assigns.ui.project_menu.toggled
    Logger.debug(status)
    Kernel.put_in(assigns, [:ui, :project_menu, :toggled], status)
  end

  def select(assigns, id) do
    assigns =
      Domain.set_current_project(assigns, id)
      |> Domain.set_default_project_version(id)
      |> Kernel.put_in([:ui, :project_menu, :toggled], false)
  end

  def close_modal(assigns) do
    Kernel.put_in(assigns, [:ui, :project_form, :toggled], false)
  end
end
