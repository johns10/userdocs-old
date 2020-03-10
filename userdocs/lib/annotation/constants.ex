defmodule Userdocs.Annotation.Constants do
  require Logger

  alias Userdocs.Helpers

  ############################## Constants ##########################

  def new_map(assigns) do
    %{
      id: Helpers.provisional_id(),

      storage_status: "web",
      record_status: "new",

      name: "",
      label: "",
      description: "",

      annotation_type_id: 1,
      annotation_type: nil,

      content_id: 1,
      content: nil,

      element_id: 1,
      element: nil
    }
  end

  def associations(assigns) do
    %{
      element: assigns.element,
      annotation_type: assigns.annotation_type,
      content: assigns.content
    }
  end

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, step) do
    Storage.Annotation.form_changeset(
      %Storage.Annotation{},
      step,
      associations(assigns)
    )
  end

end
