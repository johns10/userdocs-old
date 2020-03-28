defmodule LiveViewWeb.InputHelpers do
  use Phoenix.HTML

  alias LiveViewWeb.Helpers

  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)
    placeholder = opts[:placeholder] || Phoenix.HTML.Form.input_type(form, field)
    select_opts = opts[:select_options] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "form-group"]
    label_opts = [class: "control-label"]
    input_opts = [
      class: "#{state_class(form, field)}",
      id: Helpers.form_id_tag(form, :name),
      placeholder: placeholder,
      "phx-debounce": "blur"
    ]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = if (type == :select) do
        input(type, form, field, select_opts, input_opts)
      else
        input(type, form, field, input_opts)
      end
      error = LiveViewWeb.ErrorHelpers.error_tag(form, field)
      help = content_tag(:small, help_text(form, field))
      [label, input, error, help || ""]
    end
  end

  def button_new(type, parent_id \\ nil, parent_type \\ nil, disabled \\ false) do
    IO.inspect(disabled)
    content_tag(
      :button,
      "New " <> String.capitalize(type),
      type: "button",
      phx_click: type <> "::new",
      class: "btn btn-success btn-lg",
      phx_value_parent_id: parent_id,
      phx_value_parent_type: parent_type,
      disabled: disabled
    )
  end

  def button_save(form, label \\ "Save") do
    { button_style, icon_class } = cond do
      Enum.count(form.source.errors) >= 1 ->
        {
          "opacity: 0.65;",
          "fa fa-exclamation-circle"
        }
      Enum.count(form.source.errors) == 0 ->
        {
          "opacity: 1;",
          "fa fa-check-circle"
        }
      true -> true
    end
    submit = submit(
      [ content_tag(:i, "", class: icon_class), " " <> label ],
      class: "btn btn-success",
      value: "save",
      style: button_style
    )
  end

  def button_remove(type, id, label \\ "Remove") do
    content_tag(
      :button,
      [
        type: "button",
        phx_click: type <> "::remove",
        class: "btn btn-danger",
        phx_value_id: id
      ]
    ) do
      [
        content_tag(:i, "", class: "fa fa-times"),
        " " <> label
        ||""
      ]
    end
  end

  def button_cancel(type, id, label \\ "Cancel") do
    content_tag(
      :button,
      [
        type: "button",
        phx_click: type <> "::cancel",
        class: "btn btn-secondary",
        phx_value_id: id
      ]
    ) do
      [
        content_tag(:i, "", class: "fa fa-arrow-left"),
        " " <> label
        || ""
      ]
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.action -> ""
      form.errors[field] -> "form-control is-invalid"
      true -> "form-control "
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  def help_text(form, field) do
    help_message = Map.get(
      %{
        name: "Enter a descriptive name.",
        url: "Enter the base URL for this project, for example: https://www.google.com",
        base_url: "Enter the base URL for this project, for example: https://www.google.com",
        project_type: "Enter your project type"
      },
      field
    )
    cond do
      # The form was not yet submitted
      !form.action -> ""
      form.errors[field] -> ""
      true -> help_message
    end
  end

  defp placeholder(form, field) do
    placeholder = Map.get(
      %{
        name: "Name"
      }
    )
  end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end

  defp input(:select, form, field, select_opts, input_opts) do
    apply(Phoenix.HTML.Form, :select, [form, field, select_opts, input_opts])
  end
end
