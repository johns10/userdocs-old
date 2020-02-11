defmodule Userdocs.Changeset do

  alias Userdocs.Data

  require Logger

  def new(assigns, object, type) do
    type_name = Macro.camelize(Atom.to_string(type))

    liveview_module = String.to_atom("Elixir.Userdocs." <>  type_name <> ".Constants")
    apply(liveview_module, :changeset, [assigns, object])
  end


  def apply_changeset({ assigns, object }, type) do
    apply_changeset( assigns, type, object )
  end
  def apply_changeset(assigns, type, object) do
    Logger.debug("Applying Changeset")
    type_name = Atom.to_string(type)
    action = Data.object_action(object)

    storage_module = String.to_atom(
      "Elixir.Storage." <> Macro.camelize(type_name))
    liveview_module = String.to_atom(
      "Elixir.Userdocs." <> Macro.camelize(type_name) <> ".Constants")
    associations = apply(liveview_module, :associations, [assigns])
    object_struct = Kernel.struct(storage_module, %{})

    changeset = apply(
      storage_module,
      :form_changeset,
      [object_struct, object, associations])

    result = Ecto.Changeset.apply_action(changeset, action)

    { assigns, result, changeset }
  end

  def assign_changeset({assigns, changeset}, type) do
    Logger.debug("It calls assign_changeset with the id from the changesets changes:")
    assign_changeset({ assigns, changeset }, type, changeset.changes.id)
  end
  def assign_changeset({assigns, changeset}, type, id) do
    Logger.debug("It assigns the #{type} Changeset specified by the id: #{id}")

    new_changesets =
      assigns.changesets[type]
      |> Map.put(id, changeset)

    { Kernel.put_in(assigns, [:changesets, type], new_changesets),
      id }
  end

  def check_old_changeset(nil, original_changeset) do
    Logger.debug("There is no old changeset, so it returns the original changeset")
    original_changeset
  end
  def check_old_changeset(old_changeset, _original_changeset) do
    Logger.debug("There is an old changeset, so it returns the old changeset")
    old_changeset
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

  def handle_changeset_result({ assigns, result, _changeset }, type) do
    handle_changeset_result({ assigns, result, }, type)
  end
  def handle_changeset_result({ assigns, { :error, changeset } }, type) do
    Logger.debug("There was an error with the changeset result")
    assign_changeset({ assigns, changeset }, type)
  end
  def handle_changeset_result({ assigns, { :ok, object } }, type) do
    Logger.debug("Handing changeset result")
    action = Data.object_action(object)
    Data.apply_state_change(object, type, action)
    assigns
  end

end
