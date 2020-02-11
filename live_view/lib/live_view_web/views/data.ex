defmodule LiveViewWeb.Data do
  use Phoenix.LiveView

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Changeset

  require Logger

  def new_struct(socket, type, function_name \\ :new_map) do
    object = new_map(socket, type, function_name)
    storage_module = String.to_atom("Elixir.Storage." <>  Macro.camelize(type))
    { socket, Kernel.struct(storage_module, object) }
  end

  def new_map(socket, type, function_name \\ :new_map) do
    liveview_module = String.to_atom("Elixir.LiveViewWeb." <>  Macro.camelize(type))
    apply(liveview_module, function_name, [socket.assigns])
  end

  def assign_new_object({ socket, object }, type) do
    { assigns, data } = StateHandlers.create(socket.assigns, String.to_atom(type), object)
    Logger.debug("Assigning new object")
    { assign(socket, assigns), Map.from_struct(object) }
  end

  def edit({ socket = %Phoenix.LiveView.Socket{}, changeset }, data, type) do
    edit(socket, data, type, changeset, Helpers.form_id(data))
  end
  def edit(socket = %Phoenix.LiveView.Socket{}, data = %{ }, type, changeset) do
    edit(socket, data, type, changeset, Helpers.form_id(data))
  end
  def edit(socket = %Phoenix.LiveView.Socket{}, data, type, changeset) do
    { socket, changeset }
  end
  def edit(socket = %Phoenix.LiveView.Socket{}, data, type, nil, id) do
    Logger.debug("It gets the object, and returns its changeset")
    object = Helpers.get_one(socket.assigns, String.to_atom(type), id)
    liveview_module = String.to_atom("Elixir.LiveViewWeb." <>  Macro.camelize(type))
    { socket, Changeset.new(socket, Map.from_struct(object), type) }
  end
  def edit(socket = %Phoenix.LiveView.Socket{}, data, type, changeset, id) do
    Logger.debug("It has a changeset, so it returns that one")
    Logger.debug(inspect(changeset))
    { socket, changeset }
  end

  def parse_args({ socket, step}) do
    { socket, parse_args(step)}
  end

  def parse_args(step = %{ args: args }) do
    step = Map.put(step, :args,
      Enum.map(args, fn(arg) -> Map.from_struct(arg) end)
    )
  end
  def parse_args(nil) do
    %{}
  end

  def remove({ socket, data }, type, storage_status) do
    socket = remove(type, storage_status, data, socket)
    { socket, }
  end
  def remove(type, "web", form_data, socket) do
    Logger.debug("Removing a web record")
    id = Helpers.form_id(form_data)
    Logger.debug(id)
    step = Helpers.get_one(socket.assigns, :step, id)
    assigns = StateHandlers.delete(socket.assigns, :step, step)
    assign(socket, assigns)
  end
  def remove(type, "state", form_data, socket) do
    Logger.debug("Removing a state record")
    id = Helpers.form_id(form_data)
    changes = Map.put(
      socket.assigns.changesets["step"][id].changes,
      :record_status,
      "removed"
    )
    changeset = Map.put(
      socket.assigns.changesets["step"][id],
      :changes,
      changes
    )
    action = Helpers.object_action(changeset.changes)

    result = Ecto.Changeset.apply_action(changeset, action)

    Changeset.handle_changeset_result({ socket, result }, "step")
  end
end
