defmodule LiveViewWeb.Page.Body do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Page
  alias LiveViewWeb.Annotations
  alias LiveViewWeb.InputHelpers

  def render(assigns, page) do
    content_tag(:div, [ class: "card-body"]) do
      [
        content_tag(:div, [ class: "card" ]) do
          [
            Page.Steps.Header.render(assigns, page),
            if page.id in assigns.active_steps do
              [
                content_tag(:ul, [ class: "card-body" ]) do
                  content_tag(:ul, [ class: "list-group" ]) do
                    Page.Steps.Body.render(assigns, page)
                  end
                end,
                content_tag(:div, [ class: "card-footer" ]) do
                  LiveViewWeb.Page.Steps.Footer.render(assigns, page.id)
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
