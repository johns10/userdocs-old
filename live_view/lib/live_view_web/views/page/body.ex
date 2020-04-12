defmodule LiveViewWeb.Page.Body do

  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Page
  alias LiveViewWeb.Steps
  alias LiveViewWeb.Annotations
  alias LiveViewWeb.InputHelpers

  def render(assigns, page) do
    content_tag(:div, [ class: "card-body"]) do
      [
        content_tag(:div, [ class: "card" ]) do
          [
            Steps.Header.render(assigns, "page", page.id),
            if page.id in assigns.active_steps do
              new_step_id = assigns.current_changesets.new_page_steps[page.id]
              #Logger.debug("rendering steps header")
              #Logger.debug(inspect(assigns.current_changesets))
              #Logger.debug(new_step_id)
              #Logger.debug(page.id)
              [
                content_tag(:ul, [ class: "card-body" ]) do
                  content_tag(:ul, [ class: "list-group" ]) do
                    Steps.Body.render(assigns, :page, page.id)
                  end
                end,
                content_tag(:div, [ class: "card-footer" ]) do
                  Steps.Footer.render(assigns, :page, page.id, new_step_id)
                end
              ]
            else
              ""
            end,
          ]
        end,
        content_tag(:div, [ class: "card" ]) do
          [
            Page.Elements.Header.render(assigns, page),
            if page.id in assigns.active_page_elements do
              [
                content_tag(:ul, [ class: "card-body" ]) do
                  Page.Elements.Body.render(assigns, page)
                end,
                content_tag(:div, [ class: "card-footer" ]) do
                  Page.Elements.Footer.render(assigns, page)
                end
              ]
            else
              ""
            end
            || ""
          ]
        end,
        content_tag(:div, [ class: "card" ]) do
          [
            Page.Annotations.Header.render(:page, page.id, assigns),
            if page.id in assigns.active_page_annotations do
              [
                content_tag(:ul, [ class: "card-body" ]) do
                  Annotations.Body.render(:page, page.id, assigns)
                end,
                content_tag(:div, [ class: "card-footer" ]) do
                  "Footer"
                end
              ]
            else
              ""
            end
            || ""
          ]
        end,
      ]
    end
  end
end
