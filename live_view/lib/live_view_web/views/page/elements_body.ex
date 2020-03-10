defmodule LiveViewWeb.Page.Elements.Body do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Page

  require Logger

  def render(assigns, page) do
    Logger.debug("Rendering Elements Body")

    { assigns, result } = StateHandlers.get_related(
      assigns,
      :page_id,
      [ page ],
      :element
    )

    [
      Enum.map(result,
        fn(element) ->
          content_tag(:li, [ class: "list-group-item" ]) do
            [
              content_tag(:div, [
                class: "d-flex w-100 justify-content-between",
                href: "#",
                phx_click: "element::expand",
                phx_value_id: element.id
              ]) do
                LiveViewWeb.Element.Header.render(assigns, element)
              end,
              if element.id in assigns.active_elements do
                changeset = assigns.changesets.element[element.id]
                LiveViewWeb.Element.Body.render(assigns, changeset, element)
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
