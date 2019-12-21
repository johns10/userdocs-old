defmodule Job.Builder do

  def build( id, object = %{ job_type: :annotate, page: page_id }) do
    IO.puts("Building page annotation job")
    IO.puts(id)
    IO.inspect(object)
    State.get(:page, page_id)
    |> Map.values()
    |> Enum.at(0)
    |> Map.get(:project)
    |> get_project_procedure()
  end

  def get_project_procedure(project_id) do
    State.get_all_related_data(:project, [project_id], :step)
    |> Enum.into([])
    |> Enum.sort(&order/2)
    |> process_steps()
  end

  def order( { _, object1 }, { _, object2 } ) do
    Map.get(object1, :order) > Map.get(object2, :order)
  end

  def process_steps(steps) do
    steps
    |> Enum.into([])
    |> Enum.reduce([], &convert_step/2)
  end

end
