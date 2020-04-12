defmodule Userdocs.Subscription do

  require Logger

  alias Userdocs.Project

  def handle_info({ type, command, object }, assigns) do
    Logger.debug("Handling a #{command} subscription for #{type}")
    Logger.debug(inspect(object))

    { assigns, object } = preprocess(
      type, command, object, assigns)

    assigns
  end

  def preprocess(type = :step, :update, object, assigns) do
    { assigns, data } = StateHandlers.update(assigns, type, object)
    { assigns, object }
  end
  def preprocess(type, :update, object, assigns) do
    current_changeset =
      assigns.changesets[Atom.to_string(type)][object.id]

    module_name =
      type
      |> Atom.to_string()
      |> Macro.camelize()

    module = String.to_atom("Elixir.Userdocs." <> module_name <> ".Constants")

    changeset = Kernel.apply(module,
      :changeset, [ assigns, Map.from_struct(object) ])

    assigns = Kernel.put_in(assigns,
      [ :changesets, type, object.id ], changeset)

    { assigns, data } = StateHandlers.update(assigns, type, object)
    { assigns, object }
  end
  def preprocess(type, :create, object, assigns) do
    Logger.debug("Handling a preprocessor for creating an #{type}")
    { assigns, data } = StateHandlers.update(assigns, type, object)
    { assigns, object }
  end
  def preprocess(type, command, object, assigns) do
    { assigns, object }
  end

end
