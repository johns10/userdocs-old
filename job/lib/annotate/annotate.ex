defmodule Job.Annotate do
  @moduledoc """
  Documentation for Job.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Job.hello()
      :world

  """
  def create_tasks( )

  def annotate_project(project_id) do
  end

  def annotate_page(page_id) do
    { :ok, pid } = WebDriver.Server.start_link()

    State.get(:page, page_id)
    |> Map.values()
    |> Enum.at(0)
    |> Map.get(:project)
    |> get_project_procedure()
    |> IO.inspect()
    |> WebDriver.execute_procedure(pid)

    page_id
    |> get_page_procedure()
    |> WebDriver.execute_procedure(pid)

    { :ok }
  end

  def get_project_data(project_id) do
    project_steps = State.get_all_related_data(:project, [project_id], :step)
    project_pages = State.get_all_related_data(:project, [project_id], :page)

  end

  def get_page_procedure(page_id) do
    State.get_all_related_data(:page, [page_id], :step)
    |> add_page_annotations_steps(page_id)
    |> Enum.into([])
    |> Enum.sort(&order/2)
    |> process_steps()
  end

  def add_page_annotations_steps(pages, page_id) do
    State.get_all_related_data(:page, [page_id], :annotation)
    |> Map.keys()
    |> get_annotation_steps()
    |> Map.merge(pages)
  end

  def get_annotation_steps(annotation_ids) do
    State.get_all_related_data(:annotation, annotation_ids, :step)
  end

  def convert_step({ _key, step }, steps) do
    [ { step.step_type, step.args } | steps ]
  end

  def process_annotations(annotations) do
    IO.inspect(annotations)
    annotations
    |> Enum.into([])
    |> Enum.reduce([], &convert_annotation/2)
  end

  def convert_annotation({ _key, annotation }, script_parameters) do
    [
      %{ type: annotation.annotation_type, args: Enum.into(annotation.args, [] ) } |
      script_parameters
    ]
  end

end
