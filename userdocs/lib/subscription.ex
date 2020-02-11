defmodule Userdocs.Subscription do

  require Logger

  alias Userdocs.Project

  def handle_info({ type, command, object }, assigns) do
    Logger.debug("Handling a #{command} subscription for #{type}")

    { assigns, object } = preprocess(
      type, command, object, assigns)

    Subscription.Handler.handle( type, command, object, assigns)
  end

  def preprocess(:step, :update, object, assigns) do
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

    { assigns, object }
  end
  def preprocess(type, command, object, assigns) do
    { assigns, object }
  end

end
