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
    Changeset.new(assigns, Map.from_struct(object), type)
  end
  def edit(_assigns, type, changeset, id) do
    Logger.debug("It has a changeset, so it returns that one")
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

  def move(items, from, to) when Kernel.abs(from - to) > 1 do
    args = move_down(from, to)
    Enum.map(
      items,
      fn(x) ->
        in_bounds = ((x.order >= args.min) && (x.order <= args.max))
        case { args.min, args.max, x.order } do
          { min, max, order } when in_bounds == true ->
            Map.put(x, :order, x.order + args.adjustment)
          { _min, _max, order } when order == from ->
            Map.put(x, :order, to)
          _ -> x
        end
      end
    )
  end
  def move(items, from, to) when Kernel.abs(from - to) == 1 do
    Logger.debug("Moving to an adjacent item")
    Enum.reduce(
      items,
      [],
      fn(i, acc) ->
        case { from, to, i.order } do
          { from, _to, order } when order == from ->
            acc = [ Map.put(i, :order, to) | acc ]
          { _from, to, order } when order == to  ->
            acc = [ Map.put(i, :order, from) | acc ]
          _ -> acc
        end
      end
    )
  end
  def move(items, from, to) when Kernel.abs(from - to) == 0 do
    Logger.debug("Moving to the same item")
    []
  end

  def move_down(source_order, target_order)
  when source_order < target_order == true do
    %{
      min: source_order + 1,
      max: target_order,
      adjustment: -1
    }
  end

  def move_down(source_order, target_order)
  when source_order < target_order == false do
    %{
      min: target_order,
      max: source_order - 1,
      adjustment: 1
    }
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

  def select(assigns, type, action) do
    list = Map.get(assigns, type)
    select(list, action)
  end

  def select(list, action) do
    list
    |> Enum.map(fn(o) -> [
      {:key, o.name},
      {:value, o.id},
      {:phx_click, action}
    ]  end)
  end

  def update_order_assigns(assigns, type, objects) do
    Logger.debug("It inserts records with updated order into the assigns")
    Enum.reduce(
      objects,
      assigns,
      fn(o, old_assigns) ->
        object =
          old_assigns
          |> Data.get_one(type, o.id)
          |> Map.put(:order, o.order)

        { assigns, _result } = StateHandlers.update(old_assigns, type, object)
        assigns
      end
    )
  end

  def update_order_state(assigns, type, objects) do
    Logger.debug("It inserts records with updated order into the state")
    Enum.each(
      objects,
      fn(o) ->
        object =
          assigns
          |> Data.get_one(type, o.id)
          |> Map.put(:order, o.order)

        State.update(type, object)
      end
    )
    assigns
  end

  def new_form() do
    %{
      mode: :new
    }
  end

  def new_page_step_form() do
    %{
      mode: :new
    }
  end

  def new_page_element_form() do
    %{
      mode: :new
    }
  end

  def new_state() do
    %{
      current_team_id: nil,
      current_project_id: nil,
      current_version_id: nil,
      show_removed_projects: true,
      active_steps: [],
      active_pages: [],
      active_elements: [],
      active_annotations: [],
      active_page_elements: [],
      active_page_annotations: [],
      active_content: [],
      page_edit: [],
      drag: %{},
      changesets: %{
        page: %{},
        step: %{},
        version: %{},
        project: %{},
        element: %{},
        annotation: %{},
        content: %{},
      },
      current_changesets: %{
        new_version_pages: %{},
        new_version_steps: %{},
        new_project_versions: %{},
        new_project: nil,
        new_page_elements: %{},
        new_content: nil
      },
      active_annotations: [],
      ui: %{

        page_dropdown: %{
          active: nil,
        },

        project_menu: %{
          toggled: false
        },
        project_form: %{
          toggled: false,
          mode: :new,
          new: nil
        },

        content_menu: %{
          toggled: false
        },
        content_form: %{
          toggled: false,
          mode: :button,
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
        version_page_control: %{
          mode: :button,
        },
        version_page_menu: %{
          toggled: false
        },
        version_step_form: %{
          toggled: false,
          new: nil
        },
        project_steps_menu: %{
          toggled: false,
          class: %{

            collapse: "collapse show"
          }
        },


        version_page_form: %{
        },
        page_element_forms: %{
        },
        page_step_forms: %{
        },
        page_annotation_forms: %{
        },
      }
    }
  end

end
