defmodule LiveViewWeb.Helpers do
  use Phoenix.LiveView

  def children(parent_type, parent_id, child_type, child_objects) do
    #IO.puts("Getting children of type #{parent_type} on #{child_type}")
    Enum.reduce(
      child_objects,
      %{},
      fn { id, object }, objects ->
        try do
          true = (object[parent_type] == parent_id)
          Map.put(objects, id, object)
        rescue
          MatchError -> objects
          objects
        end
      end
    )
  end

  def get(socket, type, keys) do
    assign(
      socket,
      Map.put(socket.assigns, type, State.get(type, keys))
    )
  end

  def get_all_related_data(socket, from_type, from_ids, to_type) do
    #IO.puts("Getting related data from #{from_type} to #{to_type}")
    State.get_all_related_data(from_type, from_ids, to_type)
    assign(
      socket,
      Map.put(socket.assigns, to_type, State.get_all_related_data(from_type, from_ids, to_type))
      )
  end

  def create({ :ok, changeset_result }, type) do
    IO.puts("Views.Helpers.create function #{type}")
    value = Map.from_struct(changeset_result)
    IO.inspect(value)
    State.create(type, String.to_atom(value.id), value)
  end

  def assign_parent_type(annotation) do
    { parent_type , annotation } = Map.pop(annotation, "parent_type")
    { parent_id, annotation } = Map.pop(annotation, "parent_id")
    Map.put(annotation, parent_type, parent_id)
  end

  def add_property(socket, type, _property, _init) do
    objects = Enum.map(
      Map.get(socket, :assigns)
      |> Map.get(type),
      fn {key, object} ->
        {key, Map.put(object, :active, false)}
      end
    )
    |> Enum.into(%{})
    assign(socket, type, objects)
  end

  def configure_injection(socket, type) do
    assign(
      socket,
      :injections,
      Map.put(socket.assigns.injections, type, [])
    )
  end

  def add_injection(socket, type, property, default) do
    assign(
      socket,
      :injections,
      injections(socket.assigns.injections, type, property, default)
    )
  end

  def injections(injections, type, property, default) do
    Map.put(
      injections,
      type,
      [ { property, default } | injections[type] ]
    )
  end

  def handle_subscription({ data, socket }) do
    IO.puts("Handling Subscription")
    { data, socket }
    |> extract_object
    |> inject_object
    |> add_object
    |> IO.inspect()

  end

  def extract_object({ data, socket }) do
    {
      data
      |> Map.to_list
      |> List.first,
      socket
    }
  end

  def inject_object({{ id, object }, socket }) do
    {
      {
        id,
        Enum.reduce(
          socket.assigns.injections[String.to_atom(object.type)],
          object,
          fn { key, value}, acc ->
            Map.put(object, key, value)
          end
        )
      },
      socket
    }
  end

  def add_object({{ id, object }, socket }) do
    type = String.to_atom(object.type)
    {
      :noreply,
      assign(
        socket,
        type,
        Map.put(socket.assigns[type], id, object)
      )
    }
  end

end
