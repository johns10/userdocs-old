defmodule LiveViewWeb.ArgView do
  use Phoenix.LiveView
  use Phoenix.HTML
  require Logger

  alias Userdocs.Data

  def render(arg, value, f, nil, assigns) do
    Logger.debug("Rendering new arg")
    render(arg, value, f, "new", assigns)
  end

  def render(nil, value, f, id, assigns) do
    "Error Rendering Arg"
  end

  def render(arg = "annotation", value, f, id, assigns) do
    Logger.debug("Rendering Element Form")
    Logger.debug(id)
    element_id = "step-" <> id <> "-" <> arg
    step = Data.get_one(assigns, :step, String.to_integer(id))
    page = Data.get_one(assigns, :page, step.page_id)
    annotations = Data.children(assigns, :page_id, page, :annotation)
    select_list = Data.select(annotations, "")
    content_tag(:div, [ class: "col-sm-3 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        select(f, :value, select_list, [
          class: "form-control p-2",
          id: element_id,
          value: value
        ])
      ]
    end
  end

  def render(arg = "element", value, f, id, assigns) do
    #Logger.debug("Rendering Element Form")
    #Logger.debug(id)
    element_id = "step-" <> id <> "-" <> arg
    step = Data.get_one(assigns, :step, String.to_integer(id))
    page = Data.get_one(assigns, :page, step.page_id)
    elements = Data.children(assigns, :page_id, page, :element)
    select_list = Data.select(elements, "")
    content_tag(:div, [ class: "col-sm-3 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        select(f, :value, select_list, [
          class: "form-control p-2",
          id: element_id,
          value: value
        ])
      ]
    end
  end

  def render(arg = "content", value, f, id, assigns) do
    Logger.debug("Rendering Content Form")
    Logger.debug(id)
    content_id = "step-" <> id <> "-" <> arg
    step = Data.get_one(assigns, :step, String.to_integer(id))
    page = Data.get_one(assigns, :page, step.page_id)
    version = Data.get_one(assigns, :version, page.version_id)
    project = Data.get_one(assigns, :project, version.project_id)
    team = Data.get_one(assigns, :team, project.team_id)
    contents = Data.children(assigns, :team_id, team, :content)
    select_list = Data.select(contents, "")
    content_tag(:div, [ class: "col-sm-3 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        select(f, :value, select_list, [
          class: "form-control p-2",
          id: content_id,
          value: value
        ])
      ]
    end
  end

  def render(arg = "text", value, f, id, assigns) do
    id = "step-" <> id <> "-" <> arg
    content_tag(:div, [ class: "col-sm-3 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        textarea(f, :value, [
          class: "form-control",
          rows: "1",
          id: "step-" <> id <> "-selector",
          value: value
        ])
      ]
    end
  end


  def render(arg = "url", value, f, id, assigns) do
    id = "step-" <> id <> "-" <> arg
    content_tag(:div, [ class: "col-sm-9 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        textarea(f, :value, [
          class: "form-control",
          rows: "1",
          id: "step-" <> id <> "-selector",
          value: value
        ])
      ]
    end
  end

  def render(arg = "selector", value, f, id, assigns) do
    id = "step-" <> id <> "-" <> arg
    content_tag(:div, [ class: "col-12 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        textarea(f, :value, [
          class: "form-control",
          id: "step-" <> id <> "-selector",
          value: value
        ])
      ]
    end
  end

  def render(arg = "strategy", value, f, id, assigns) do
    id = "step-" <> id <> "-" <> arg
    content_tag(:div, [ class: "col-sm-3 my-1" ]) do
      [
        content_tag(:label, [ for: id ]) do
          arg
        end,
        hidden_input(f, :key, [ value: arg ]),
        select(f, :value, [ :xpath, :id, ], [
          class: "form-control p-2",
          id: id,
          value: value
        ])
      ]
    end
  end

  def render(arg, value, f, id, assigns) do
    Logger.debug("Rendering the args catch")
    Logger.debug(arg)
    id = "step-" <> id <> "-" <> arg
    [
      content_tag(:label, [ for: id ]) do
        arg
      end,
      hidden_input(f, :key, [ value: arg ]),
      text_input(f, :value, [
        class: "form-control",
        id: id,
        value: value
      ])
    ]
  end

  def render("procedure", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-procedure" %>
    >
      Procedure
    </label>
    <%= hidden_input f, :key, value: "procedure" %>
    <%=
      text_input f, :value,
      class: "form-control",
      id: "step-" <> id <> "-procedure",
      value: value
    %>
    """
  end

  def render("types", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-types" %>
    >
      Procedure
    </label>
    <%= hidden_input f, :key, value: "types" %>
    <%=
      text_input f, :value,
      class: "form-control",
      id: "step-" <> id <> "-types",
      value: value
    %>
    """
  end
  def mount(_session, socket) do
    { :ok, socket }
  end
end
