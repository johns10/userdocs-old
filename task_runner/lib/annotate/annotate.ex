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
    types = Map.merge(
      State.get(:annotation_type, []),
      State.get(:selector_type, [])
    )

    IO.inspect(self())

    State.get_all_related_data(:page, [page_id], :step)
    |> Enum.into([])
    |> Enum.sort(
      fn({ _, object1 }, { _, object2 }) ->
        Map.get(object1, :order) < Map.get(object2, :order)
      end)
    |> process_steps()
    |> IO.inspect()
    #|> WebDriver.execute_procedure()

    script_parameters = State.get_all_related_data(:page, [page_id], :annotation)
    |> process_annotations()
    |> Script.generate_script('', types)
  end

  def process_steps(steps) do
    steps
    |> Enum.into([])
    |> Enum.reduce([], &convert_step/2)
  end

  def convert_step({ key, step }, steps) do
    [ { step.step_type, step.args } | steps ]
  end

  def process_annotations(annotations) do
    annotations
    |> Enum.into([])
    |> Enum.reduce([], &convert_annotation/2)
  end

  def convert_annotation({ key, annotation }, script_parameters) do
    [
      %{ type: annotation.strategy, args: [ selector: annotation.selector ] },
      %{ type: annotation.annotation_type, args: Enum.into(annotation.args, [] ) } |
      script_parameters
    ]
  end

end
