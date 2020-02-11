defmodule LiveViewWeb.Changeset do
  use Phoenix.LiveView

  alias LiveViewWeb.Helpers

  require Logger

  def new(object, socket = %Phoenix.LiveView.Socket{}, type) do
    changeset = new(socket, object , type)
    { socket, changeset }
  end
  def new({ socket = %Phoenix.LiveView.Socket{}, object }, type) do
    changeset = new(socket, object, type)
    { socket, changeset }
  end
  def new(socket = %Phoenix.LiveView.Socket{}, object, type) do
    liveview_module = String.to_atom("Elixir.LiveViewWeb." <>  Macro.camelize(type))
    apply(liveview_module, :changeset, [socket.assigns, object])
  end

  def assign_changeset({socket, changeset}, type) do
    Logger.debug("It calls assign_changeset with the id from the changesets changes:")
    assign_changeset({ socket, changeset }, type, changeset.changes.id)
  end
  def assign_changeset({socket, changeset}, type, id) do
    Logger.debug("It assigns the #{type} Changeset specified by the id: #{id}")
    Logger.debug(inspect(changeset))
    Logger.debug(type)
    Logger.debug(inspect(socket))

    new_changesets =
      socket.assigns.changesets[type]
      |> Map.put(id, changeset)

    { Helpers.put_in_socket(socket, [:changesets, type], new_changesets),
      id }
  end

  def apply_changeset({ socket, object }, type) do
    apply_changeset( object, type, socket )
  end
  def apply_changeset({ socket, type, object }, :changeset) do
    apply_changeset({ object, type, socket })
  end
  def apply_changeset(object, type, socket) do
    { socket, result, changeset } =
      apply_changeset({ object, type, socket })
    { socket, result }
  end
  def apply_changeset({ object, type, socket }) do
    Logger.debug("Applying Changeset")
    action = Helpers.object_action(object)
    storage_module = String.to_atom("Elixir.Storage." <> Macro.camelize(type))
    liveview_module = String.to_atom("Elixir.LiveViewWeb." <> Macro.camelize(type))
    associations = apply(liveview_module, :associations, [socket.assigns])

    object_struct = Kernel.struct(storage_module, %{})

    changeset = apply(
      storage_module,
      :form_changeset,
      [object_struct, object, associations])

    result = Ecto.Changeset.apply_action(changeset, action)

    { socket, result, changeset }
  end

  def handle_changeset_result({ socket, { :error, changeset } }, type) do
    Logger.debug("There was an error with the changeset result")
    assign_changeset({ socket, changeset }, type)
  end
  def handle_changeset_result({ socket, { :ok, object } }, type) do
    Logger.debug(inspect(object))
    action = Helpers.object_action(object)
    Helpers.apply_state_change(object, String.to_atom(type), action)
    socket
  end

  def assign_new_changeset_id({socket, id}, path) do
    Helpers.put_in_socket(socket, path, id)
  end

  def check_old_changeset(nil, original_changeset) do
    Logger.debug("There is no old changeset, so it returns the original changeset")
    original_changeset
  end
  def check_old_changeset(old_changeset, _original_changeset) do
    Logger.debug("There is an old changeset, so it returns the old changeset")
    old_changeset
  end

  def check_original_changeset(socket, type, object = %Storage.Step{}, _step_form) do
    Logger.debug("The orignal step object exists, return the original changeset")
    new(socket, Map.from_struct(object), type)
  end
  def check_original_changeset(socket, type, %{}, form) do
    Logger.debug("The orignal step object is nil, return the current changeset")
    new(socket, form, type)
  end

  def check_type_change(true, _old_args, new_args, args_list) do
    Logger.debug("The type of the record didn't change")
    new_args
  end
  def check_type_change(false, old_args, _new_args, args_list) do
    Logger.debug("The type of the record changed")
    #old_args = old_changeset.changes.args
    new_args =
      Enum.reduce(
        args_list,
        %{},
        fn id, acc ->
          Map.put(
            acc,
            Integer.to_string(Enum.count(Map.keys(acc))),
            %{ "key" => id, "value" => "" }
          )
        end
      )
    Logger.debug("It merges the relevant old args into empty args")
    Map.merge(new_args, args_to_copy(old_args, args_list))
  end

  def args_to_copy(nil, args_list), do: %{}
  def args_to_copy(args, args_list) do
    Enum.filter(args,
    fn({ key, arg}) ->
      arg["key"] in args_list
    end)
    |> Enum.reduce(%{},
      fn({ key, arg }, acc) ->
        Map.put(acc, key, arg)
      end)
  end


end
