defmodule LiveViewWeb.Pages.Body do
    use Phoenix.LiveView
    use Phoenix.HTML
  
    require Logger
  
    alias LiveViewWeb.Helpers
    alias LiveViewWeb.InputHelpers
    alias LiveViewWeb.Page
  
    def render(assigns, current_version) do
      { assigns, result } = StateHandlers.get_related(
        assigns,
        :version_id,
        [ current_version ],
        :page
      )

      content_tag(:div, [class: "card-body"]) do
        steps = Enum.map(result,
          fn(page) ->
            if (page.id in assigns.active_pages) do
              content_tag(:div, [ class: "card" ]) do
                [
                  _header = Page.Header.render(assigns, assigns.changesets.page[page.id], page),
                  _page_body = Page.Body.render(assigns, page),
                  _version_page_control = content_tag(:div, [class: "card-footer"]) do
                    Page.Footer.render(assigns, page.id)
                  end
                  || ""
                ]
              end
            else
              if (page.storage_status == "state")  do
                #Logger.debug("Rendering header")
                changeset = assigns.changesets.page[page.id]
                content_tag(:div, [ class: "card" ]) do
                  [
                    _header =
                      Page.Header.render(assigns, changeset, page)
                    || ""
                  ]
                end
              else
                ""
              end
            end
          end
        )
      end
    end
    
  end
  
  
  