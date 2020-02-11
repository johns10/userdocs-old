defmodule LiveViewWeb.ErrorHelpers do

  use Phoenix.HTML

  def error_tag(form, field) do
    IO.puts("It creates the error text")
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error), class: "invalid-feedback")
    end)
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(LiveViewWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(LiveViewWeb.Gettext, "errors", msg, opts)
    end
  end
end
