defmodule TaskRunner.Annotate do
  @moduledoc """
  Documentation for TaskRunner.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TaskRunner.hello()
      :world

  """
  def annotate_project(project_id) do
  end

  def get_project_data(project_id) do
    project_steps = State.get_all_related_data(:project, [project_id], :step)
    project_pages = State.get_all_related_data(:project, [project_id], :page)

  end

  def get_page_procedure(page_id) do
    State.get_all_related_data(:page, [page_id], :step)
    |> Enum.into([])
    |> Enum.sort(
      fn({ _, object1 }, { _, object2 }) ->
        Map.get(object1, :order) < Map.get(object2, :order)
      end)
    #|> IO.inspect()

    State.get_all_related_data(:page, [page_id], :annotation)
    #|> IO.inspect()

    State.get(:annotation_type, [])
    |> IO.inspect()

    #IO.puts("Here's the steps")
    #IO.inspect(Map.keys(steps))
    #IO.inspect(steps)
    """
    Enum.reduce(
      steps,
      [],
      fn({ id, object }, steps_list) ->
        { order, updated_object } = Map.pop(object, :order)
        #IO.inspect(order)
        #IO.inspect(updated_object)
        #IO.inspect({ order, updated_object })
        [ { order, updated_object } | steps_list ]
      end
    )
    |> IO.inspect
    """
    #Enum.sort(steps, &(Map.get(&1, :order) >= Map.get(&2, :order)))
    #|> IO.inspect
    #annotations = State.get_all_related_data(:page, [page_id], :annotation)
    #IO.puts("Here's the annotations")
    #IO.inspect(Map.keys(annotations))
  end
end
