defmodule LiveViewWeb.Content.Menu do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.ErrorHelpers
  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Content

  def render(assigns) do
    Logger.debug("Rendering Content Menu")
    team = Userdocs.Data.get_one(assigns, :team, assigns.current_team_id)
    { assigns, result } = StateHandlers.get_related(
      assigns,
      :team_id,
      [ team ],
      :content
    )
    content_tag(:div, [
      class: "modal fade show",
      id: "contentModal",
      tabindex: "-1",
      role: "dialog",
      aria_labelledby: "contentModalLabel",
      aria_hidden: "true",
      style: "display: block; padding-right: 17px"
    ]) do
      content_tag(:div, [ class: "modal-dialog modal-dialog-scrollable", role: "document" ]) do
        content_tag(:div, [ class: "modal-content" ]) do
          [
            content_tag(:div, [ class: "modal-header" ]) do
              [
                content_tag(:h5, [
                  class: "modal-title",
                  id: "contentModalLabel"
                ]) do
                  "Content"
                end,
                content_tag(:button, [
                  type: "button",
                  class: "close",
                  data_dismiss: "modal",
                  aria_label: "Close",
                  phx_click: "content::close_modal",
                ]) do
                  content_tag(:i, [ class: "fa fa-times" ]) do
                    ""
                  end
                end
              ]
            end,
            content_tag(:div, [ class: "modal-body" ]) do
              [
                for object <- result do
                  if (object.storage_status == "web") do
                    ""
                  else
                    content_tag(:li, [class: "list-group-item"]) do
                      if object.id in assigns.active_content do
                        Logger.debug("Fixing to render content entries")
                        [
                          Content.Header.render(object, assigns),
                          Content.Form.render(
                            assigns.changesets.content[object.id],
                            object,
                            assigns
                          )
                        ]
                      else
                        Content.Header.render(object, assigns)
                      end
                    end
                  end
                end
              ]
            end,
            content_tag(:div, [ class: "modal-footer" ]) do
              [
                if assigns.ui.content_form.mode == :button do
                  LiveViewWeb.Content.Button.New.render(assigns)
                else
                  id = assigns.current_changesets.new_content
                  object = Userdocs.Data.get_one(assigns, :content, id)
                  Logger.debug(inspect(id))
                  Logger.debug(inspect(object))
                  [
                    Content.Header.render(object, assigns),
                    LiveViewWeb.Content.Form.render(
                      assigns.changesets.content[id],
                      object,
                      assigns
                    )
                  ]
                end
              ]
            end
          ]
        end
      end
    end
  end
end
