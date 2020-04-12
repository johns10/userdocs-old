defmodule LiveViewWeb.Step.WholeStep do
    use Phoenix.LiveView
    use Phoenix.HTML
  
    require Logger
  
    alias LiveViewWeb.Helpers
    alias LiveViewWeb.Types
    alias LiveViewWeb.InputHelpers
    alias LiveViewWeb.Step
  
    def render(step, assigns, parent_type, parent_id) do
      content_tag(
        :li, [class: "list-group-item", 
        href: "#",
        phx_hook: "drag_drop_zone",
        id: step.id,
        type: "step",
        parent_type: parent_type,
        parent_id: parent_id,
        draggable: "true"
      ] ) do
        [
          Step.Header.render(
          step,
          assigns,
          "step::expand",
          "page",
          step.page_id
          ),
          if step.id in assigns.active_steps do
          Step.Form.render(
            assigns.changesets.step[step.id],
            step,
            assigns
          )
          else
          ""
          end
        ]
      end
    end
    
  end
  
  
  