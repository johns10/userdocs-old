defmodule Userdocs.Content.Constants do
  require Logger

  alias Userdocs.Helpers

  ############################## Constants ##########################

  def new_map(assigns) do
    team = Enum.at(assigns.team, 0)

    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      name: "",
      description: "",

      team_id: team.id,
      team: nil
    }
  end

  def associations(assigns) do
    %{team: assigns.team}
  end

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, object) do
    storage_module = Storage.Content
    struct_prototype = %Storage.Content{}

    storage_module.form_changeset(
      struct_prototype,
      object,
      associations(assigns)
    )
  end
end
