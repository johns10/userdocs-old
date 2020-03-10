defmodule Userdocs.Page.Constants do
  require Logger

  alias Userdocs.Helpers

  ############################## Constants ##########################

  def new_map(assigns) do
    version_id = assigns.current_version_id
    %{

      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      url: "",
      version_id: version_id
    }
  end

  def associations(assigns) do
    %{version: assigns.version}
  end

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, page) do
    Storage.Page.form_changeset(
      %Storage.Page{},
      page,
      associations(assigns)
    )
  end

end
