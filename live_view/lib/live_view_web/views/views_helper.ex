defmodule LiveViewWeb.Helpers do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  def default_assigns(socket) do
    assign(socket,
      current_project_id: nil,
      current_version_id: nil,
      show_removed_projects: true,
      active_steps: [],
      active_pages: [],
      drag: %{},
      changesets: %{
        "step" => %{},
        "project" => %{},
        "annotation" => %{},
        "version" => %{},
        "new-project-steps" => %{},
        "new-page-step" => %{},
      },
      current_changesets: %{
        "new-project" => nil,
        "new-project-versions" => %{},
        "new-version-pages" => %{},
        "new-version-steps" => %{}
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
        "project-step-form" => %{
          "toggled" => false,
          "new" => nil
        },
        "project-menu" => %{
          "toggled" => false
        },
        "project-form" => %{
          "toggled" => false,
          "mode" => :new,
          "new" => nil
        },
        "version-menu" => %{
          "toggled" => false
        },
        "version-form" => %{
          "toggled" => false,
          "mode" => :new,
          "new" => nil
        },
        "page-menu" => %{
          "toggled" => false,
          "active-pages" => [],
          "active-steps" => [],
          "active-annotations" => [],
          "new-step-changesets" => %{},
          "new-annotations" => %{},
          "form-modes" => %{}
        }
      }
    )
  end

  ################################CRUD################################


  def get_one({ socket = %Phoenix.LiveView.Socket{}, type, id }) do
    { socket, get_one(socket.assigns, type, id) }
  end
  def get_one(socket = %Phoenix.LiveView.Socket{}, type, id ) do
    get_one(socket.assigns, type, id)
  end
  def get_one(assigns, type, id) do
    { assigns, result } = StateHandlers.get(assigns, type, [ id ])
    result
    |> Enum.at(0)
  end

  def get(socket, type, keys) do
    assign(
      socket,
      Map.put(socket.assigns, type, State.get(type, keys))
    )
  end

  def get_all_related_data(socket, from_type, from_ids, to_type) do
    #IO.puts("Getting related data from #{from_type} to #{to_type}")
    objects = State.get_all_related_data(from_type, from_ids, to_type) ++ socket.assigns[to_type]

    assign(socket, Map.put(socket.assigns, to_type, objects))
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

  def has_children(parent_type, parent_id, child_objects) do
    Enum.reduce(
      child_objects,
      false,
      fn({ id, object }, has_children ) ->
        if parent_id == object[parent_type] do
          true
        end
      end
    )
  end

  def forward_ids(objects, id_type) do
    #IO.puts("Forward ID's")
    objects
    |> Enum.map(fn(o) -> Map.fetch!(o, id_type) end)
  end

  def create({ :ok, changeset_result }, type) do
    #IO.puts("Views.Helpers.create function #{type}")
    value = Map.from_struct(changeset_result)
    State.create(type, value)
  end
  def create(value, id, type) do
    State.create(type, id, value)
  end

  def update({ :ok, changeset_result }, type) do
    State.update(type, changeset_result)
  end

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

  def apply_changeset(changeset, storage, object, associations, action) do
    changeset
    |> storage.form_changeset(object, associations)
    |> Ecto.Changeset.apply_action(action)
  end

  def to_map({ socket, object_struct }) do
    { socket, Map.from_struct(object_struct) }
  end


  #########################CRUD Helpers#####################

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

  def convert("true"), do: true
  def convert("false"), do: false

  #TODO: this breaks with one child.  Fix it
  def select(assigns, type) do
    Map.get(assigns, type)
    |> Enum.map(fn(o) -> [ {:key, o.name}, {:value, o.id}, {:"phx-click", "select_step_type"} ]  end)
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
    end)
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
    Logger.debug(from)
    Logger.debug(to)
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


  def update_order_socket({ socket, type, objects }) do
    Logger.debug("It inserts records with updated order into the socket")
    assigns = Enum.reduce(
      objects,
      socket.assigns,
      fn(o, acc) ->
        object =
          socket
          |> get_one(type, o.id)
          |> Map.put(:order, o.order)

        { assigns, _result } = StateHandlers.update(acc, type, object)
        assigns
      end
    )
    assign(socket, assigns)
  end

  def insert_state({ socket, args }) do
    Logger.debug("It inserts a record with order #{args.source.order} into the state")
    Enum.each(args.result,
      fn(o) -> _result = State.update(args.child_type, o) end)

    updated_child = Map.put(args.source, :order, args.target_position)
    State.update(args.child_type, updated_child)

    socket
  end

  def form_id(object) do
    id = Map.get(object, "id")
    id = get_id(id)
    id
  end

  def get_id(id) when is_binary(id) do
    try do
      String.to_integer(id)
    rescue
      e in ArgumentError -> id
    end
  end
  def get_id(id) when is_integer(id), do: id
  def get_id(id), do: id

  def provisional_id() do
    :rand.uniform(10000000) + 10000000
  end

  ################################UI###################################

  def new(socket, object, changeset) do
    object =
      Map.put(
        object,
        :changeset,
        changeset
      )

    { socket, changeset }
  end

  def edit(data, socket, type, id, changeset) do
    id = Helpers.form_id(data)
    {assigns, objects} = StateHandlers.get(socket.assigns, type, [id])
    object = Enum.at(objects, 0)
    changeset = changeset.(socket.assigns, Map.from_struct(object))
    object = Map.put(object, :changeset, changeset)
    {assigns, _result} = StateHandlers.update(socket.assigns, type, object)
    assign(socket, assigns)
  end

  def set_removed({ socket, id }, type) do
    project =
      get_one(socket.assigns, type, id)
      |> Map.put(:record_status, "removed")
      |> Map.from_struct()

    { socket, project }
  end

  def put_in_socket({ socket, value }, path) do
    put_in_socket(socket, path, value)
  end
  def put_in_socket(socket, path, value) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in(path, value)

    assign(socket, assigns)
  end

  def expand(socket, id, list) do
    active_objects =
      socket.assigns[list]
      |> Enum.member?(id)
      |> toggle_active_element(socket, id, list)

    assigns =
      Map.get(socket, :assigns)
      |> Map.put(list, active_objects)

    assign(socket, assigns)
  end

  def toggle_active_element(false, socket, id, list) do
    IO.puts("Element Not Active")
    [id | socket.assigns[list]]
  end
  def toggle_active_element(true, socket, id, list) do
    IO.puts("Element Active")

    Enum.filter(
      socket.assigns[list],
      fn o ->
        o != id
      end
    )
  end

  def socket_only({socket, _ }) do
    socket
  end
  def socket_only(socket) do
    socket
  end

  def form_id_tag(f, field_name) do
    f.name
    <> "::"
    <> Integer.to_string(get_id(f.params["id"]))
    <> "::"
    <> Atom.to_string(field_name)
  end
end
