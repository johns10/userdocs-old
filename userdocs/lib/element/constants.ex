defmodule Userdocs.Element.Constants do
  require Logger

  alias Userdocs.Helpers

  ############################## Constants ##########################

  def new_map(assigns, page_id) do
    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      name: "",
      description: "",
      strategy: "xpath",
      selector: "",
      page_id: page_id,
    }
  end

  def associations(assigns) do
    %{
      page: assigns.page
    }
  end

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, step) do
    Storage.Element.form_changeset(
      %Storage.Element{},
      step,
      associations(assigns)
    )
  end

end
