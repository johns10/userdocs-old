defmodule LiveViewWeb.ArgView do
  use Phoenix.LiveView
  use Phoenix.HTML
  require Logger

  def render(arg, value, f, nil, assigns) do
    Logger.debug("Rendering new arg")
    render(arg, value, f, "new", assigns)
  end

  def render("url", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-url" %>
    >
      URL
    </label>
    <%= hidden_input f, :key, value: "url" %>
    <%=
      text_input f, :value,
      class: "form-control",
      id: "step-" <> id <> "-url",
      value: value
    %>
    """
  end

  def render("selector", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-selector" %>
    >
      Selector
    </label>
    <%= hidden_input f, :key, value: "selector" %>
    <%=
      textarea f, :value,
      class: "form-control",
      id: "step-" <> id <> "-selector",
      value: value
    %>
    """
  end

  def render("strategy", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-strategy" %>
    >
      Strategy
    </label>
    <%= hidden_input f, :key, value: "strategy" %>
    <%=
      select f, :value,
      [ :xpath, :id ],
      class: "form-control",
      id: "step-" <> id <> "-strategy",
      value: value
    %>
    """
  end

  def render("text", value, f, id, assigns) do
    ~L"""
    <label
      for=<%= "step-" <> id <> "-text" %>
    >
      Input
    </label>
    <%= hidden_input f, :key, value: "text" %>
    <%=
      text_input f, :value,
      class: "form-control",
      id: "step-" <> id <> "-text",
      value: value
    %>
    """
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

  def render(arg, value, f, id, assigns) do
    ~L"""
    <label
      for=<%=
        "step-" <> id <> "-" <> arg
        %>
    >
      <%= arg %>
    </label>
    <%= hidden_input f, :key, value: arg %>
    <%=
      text_input f, :value,
      class: "form-control",
      id: "step-" <> id <> "-" <> arg,
      value: value
    %>
    """
  end

  def mount(_session, socket) do
    { :ok, socket }
  end
end
