defmodule LiveViewWeb.Pages.Header do
    use Phoenix.LiveView
    use Phoenix.HTML
  
    require Logger
  
    alias LiveViewWeb.Helpers
    alias LiveViewWeb.InputHelpers
    alias LiveViewWeb.Page
  
    def render(assigns) do
      content_tag(:h2, [class: "card-header"]) do
        "Project Pages"
      end
    end
    
  end
  
  
  