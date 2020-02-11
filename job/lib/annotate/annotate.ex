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
"""
  def annotate_page(page_id) do
    { :ok, pid } = WebDriver.Server.start_link()

    State.get(:page, page_id)
    |> Map.values()
    |> Enum.at(0)
    |> Map.get(:project)
    |> get_project_procedure()
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

  def process_annotations(annotations) do
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

  """

end
