defmodule LiveViewWeb.Annotation.Form do
    use Phoenix.LiveView
    use Phoenix.HTML
  
    alias LiveViewWeb.Helpers
    alias LiveViewWeb.Types
    alias LiveViewWeb.InputHelpers
  
    require Logger
  
    def render(changeset, object, assigns) do
      f = form_for(changeset, "#", [  ])
      Logger.debug("Rendering Step Form")
      content_tag(:form, [ phx_submit: :"annotation::save", phx_change: :"annotation::validate" ]) do
        [
          hidden_input(f, :id, [value: f.params["id"]]),
          hidden_input(f, :storage_status, [value: f.params["storage_status"]]),
          hidden_input(f, :record_status, [value: f.params["record_status"]]),
          hidden_input(f, :page_id, [value: f.params["page_id"]]),
          hidden_input(f, :order, [value: f.params["order"]]),
          content_tag(:div, [ class: "form-group form-row align-items-center" ]) do
            [
              content_tag(:div, [ class: "col-sm-12 my-1" ]) do
                InputHelpers.input(f, :label,
                  using: :text_input,
                  value: f.params["label"],
                  id: "annotation::label::select",
                  placeholder: "Label"
                )
              end,
              content_tag(:div, [ class: "col-sm-3 my-1" ]) do
                [
                  content_tag(:label, []) do
                    "Annotation Type"
                  end,
                  select(f, :step_type_id, Helpers.select(assigns, :annotation_type), [
                  value: f.params["annotation_type_id"],
                  id: "annotation::annotation_type::select",
                  class: "form-control"
                  ])
                ]
              end,
              content_tag(:div, [ class: "col-sm-3 my-1" ]) do
                [
                  content_tag(:label, []) do
                    "Element"
                  end,
                  select(f, :element_id, Helpers.select(assigns, :element), [
                  value: f.params["element_id"],
                  id: "annotation::element_id::select",
                  class: "form-control"
                  ])
                ]
              end,
              content_tag(:div, [ class: "col-sm-3 my-1" ]) do
                [
                  content_tag(:label, []) do
                    "Content"
                  end,
                  select(f, :content_id, Helpers.select(assigns, :content), [
                  value: f.params["content_id"],
                  id: "annotation::content_id::select",
                  class: "form-control"
                  ])
                ]
              end
            ]
          end,
          content_tag(:div, [ class: "modal-footer" ]) do
            [
              InputHelpers.button_save(f),
              InputHelpers.button_remove("annotation", changeset.changes.id),
              InputHelpers.button_cancel("annotation", changeset.changes.id)
              || ""
            ]
          end
          || ""
        ]
      end
    end
  end
  
  