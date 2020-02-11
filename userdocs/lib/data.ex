defmodule Userdocs.Data do

  alias Userdocs.Changeset
  alias Userdocs.Data

  require Logger

  def apply_state_change({:ok, changeset_result}, type, :update) do
    Logger.debug("Applying update state change")
    State.update(type, changeset_result)
  end
  def apply_state_change({:ok, changeset_result}, type, :insert) do
    Logger.debug("Applying create state change")
    State.create(type, changeset_result)
  end
  def apply_state_change(changeset_result, type, action) do
    Logger.debug("Applying state change without ID.")
    apply_state_change({:ok, changeset_result}, type, action)
  end

  def children(assigns, parent_type, parent, child_type) do
    { assigns, result } = StateHandlers.get_related(
      assigns,
      parent_type,
      [ parent ],
      child_type
    )
    result
  end
  def children(assigns, parent_type, parent, child_type, :asc) do
    { assigns, result } = StateHandlers.get_related(
      assigns,
      parent_type,
      [ parent ],
      child_type
    )
    result
    |> Enum.sort(&(&1.order <= &2.order))
  end

  def edit(assigns, type, nil, id) do
    Logger.debug("It gets the object, and returns its changeset")
    object = get_one(assigns, type, id)
    Logger.debug(id)
    Logger.debug(type)
    Logger.debug(inspect(object))
    Changeset.new(assigns, Map.from_struct(object), type)
  end
  def edit(_assigns, type, changeset, id) do
    Logger.debug("It has a changeset, so it returns that one")
    Logger.debug(inspect(changeset))
    changeset
  end

  def set_removed({ assigns, id }, type) do
    project =
      get_one(assigns, type, id)
      |> Map.put(:record_status, "removed")
      |> Map.from_struct()

    { assigns, project }
  end

  def get_one(assigns, type, id) do
    { assigns, result } = StateHandlers.get(assigns, type, [ id ])
    result
    |> Enum.at(0)
  end

  def max_order(assigns, parent_type, parent, child_type) do
    Logger.debug("It gets the max order")
    { assigns, result } = StateHandlers.get_related(
      assigns, parent_type, [ parent ], child_type)
    result
    |> Enum.reduce(1, &max(&1.order, &2))
    |> Kernel.+(1)
  end

  def new_struct(assigns, type, function_name \\ :new_map) do
    object = new_map(assigns, type, function_name)
    storage_module = String.to_atom("Elixir.Storage." <>  Macro.camelize(type))
    { assigns, Kernel.struct(storage_module, object) }
  end

  def new_map(assigns, type, function_name \\ :new_map) do
    liveview_module = String.to_atom("Elixir.Userdocs." <>  Macro.camelize(type) <> ".Constants")
    apply(liveview_module, function_name, [assigns])
  end

  def object_action(%{storage_status: storage_status, record_status: record_status}) do
    object_action(storage_status, record_status)
  end
  def object_action(%{"storage_status" => storage_status, "record_status" => record_status}) do
    object_action(storage_status, record_status)
  end
  def object_action("web", "new") do
    :insert
  end
  def object_action("web", "removed") do
    :update
  end
  def object_action("web", "existing") do
    :update
  end
  def object_action("state", _) do
    :update
  end
  def object_action("", _) do
    :update
  end
  def object_action("database", _) do
    :update
  end
  def object_action(:web, :new) do
    :insert
  end
  def object_action(:web, :existing) do
    :update
  end
  def object_action(:state, _) do
    :update
  end
  def object_action(nil, _) do
    :update
  end
  def object_action(:database, _) do
    :update
  end

  def parse_args({ assigns, step}) do
    { assigns, parse_args(step)}
  end

  def parse_args(step = %{ args: args }) do
    step = Map.put(step, :args,
      Enum.map(args, fn(arg) -> Map.from_struct(arg) end)
    )
  end
  def parse_args(nil) do
    %{}
  end

  def remove(type, "web", id, assigns) do
    Logger.debug("Removing a web record with id #{id}")
    Logger.debug(id)
    object = Data.get_one(assigns, type, id)
    StateHandlers.delete(assigns, type, object)
  end
  def remove(type, "state", id, assigns) do
    Logger.debug("Removing a state record with id #{id}")
    changes = Map.put(
      assigns.changesets[type][id].changes,
      :record_status,
      "removed"
    )
    changeset = Map.put(
      assigns.changesets[type][id],
      :changes,
      changes
    )
    action = Data.object_action(changeset.changes)

    result = Ecto.Changeset.apply_action(changeset, action)

    Changeset.handle_changeset_result({ assigns, result }, type)
  end

  def reorder_start(assigns, data, key) do
    assigns = Map.put(assigns, key, data)
  end

  def reorder_drag(assigns, data, id) do
    data = assigns.drag
    Logger.debug(inspect(assigns.drag))
    target = Helpers.get_one(assigns, :step, id)
    source = Helpers.get_one(assigns, :step,
      Helpers.get_id(data["source-id"]))
    parent = Helpers.get_one(assigns, :version,
      Helpers.get_id(data["parent-id"]))

    { assigns, steps } = StateHandlers.get_related(
      assigns, :version_id, [ parent ], :step)

    Logger.debug("Moving id: #{source.id}, order: #{source.order}")
    Logger.debug("       to: #{target.id}, order: #{target.order}")

    reordered_steps = Helpers.move(steps, source.order, target.order)

    Logger.debug(inspect(target.id))
    #data = Map.put(data, "source-id", Integer.to_string(target.id))
    Logger.debug(inspect(data))

    #socket = put_in_socket(socket, [ :drag ], data)

    assigns = update_order_assigns({ assigns, :step, reordered_steps })
  end

  def update_order_assigns({ socket, type, objects }) do
    Logger.debug("It inserts records with updated order into the socket")
    Enum.reduce(
      objects,
      socket.assigns,
      fn(o, acc) ->
        object =
          socket
          |> Data.get_one(type, o.id)
          |> Map.put(:order, o.order)

        { assigns, _result } = StateHandlers.update(acc, type, object)
        assigns
      end
    )
  end

  def new_state() do
    %{
      current_project_id: nil,
      current_version_id: nil,
      show_removed_projects: true,
      active_steps: [],
      active_pages: [],
      drag: %{},
      changesets: %{
        "annotation" => %{},
        "new-project-steps" => %{},
        "new-page-step" => %{},
        step: %{},
        version: %{},
        project: %{},
      },
      current_changesets: %{
        "new-version-pages" => %{},
        new_version_steps: %{},
        new_project_versions: %{},
        new_project: nil,
      },
      active_annotations: [],
      ui: %{
        "project-steps-menu" => %{
          "expanded" => "true",
          "update-step-menu" => "false",
          "update-step" => nil,
          "new-step-menu" => "false",
          "toggled" => false,
          "mode" => :new,
          "active" => [],
          "editable" => [nil],
          class: %{
            collapse: "collapse show"
          }
        },
        "page-menu" => %{
          "toggled" => false,
          "active-pages" => [],
          "active-steps" => [],
          "active-annotations" => [],
          "new-step-changesets" => %{},
          "new-annotations" => %{},
          "form-modes" => %{}
        },
        project_step_form: %{
          toggled: false,
          new: nil
        },
        version_menu: %{
          toggled: false
        },
        version_form: %{
          toggled: false,
          mode: :new,
          new: nil
        },
        project_menu: %{
          toggled: false
        },
        project_form: %{
          toggled: false,
          mode: :new,
          new: nil
        },
      }
    }
  end

end
