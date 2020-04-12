defmodule LiveViewWeb.Annotations.Body do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Page
  alias Userdocs.Data

  require Logger

  def render(parent_type, parent_id, assigns) do
    Logger.debug("Rendering Annotations Body")
    type = :annotation

    page = Data.get_one(assigns, parent_type, parent_id)

    { assigns, result } = StateHandlers.get_related(
      assigns,
      :page_id,
      [ page ],
      type
    )

    [
      Enum.map(result,
        fn(object) ->
          content_tag(:li, [ class: "list-group-item" ]) do
            [
              content_tag(:div, [
                class: "d-flex w-100 justify-content-between",
                href: "#",
                phx_click: Atom.to_string(type) <> "::expand",
                phx_value_id: object.id
              ]) do
                LiveViewWeb.Annotation.Header.render(object, parent_type, parent_id, assigns)
              end,
              if object.id in assigns.active_annotations do
                changeset = assigns.changesets.annotation[object.id]
                LiveViewWeb.Annotation.Form.render(changeset, object, assigns)
              end
              || ""
            ]
          end
        end
      )
      || ""
    ]
  end

end
