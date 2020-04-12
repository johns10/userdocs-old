defmodule Job.Builder do

  alias Job.Helpers

  def build( job_id, %{ job_type: :annotate, page: page_id }) do
    #IO.puts("Building page annotation job")
    State.create(
      :task,
      String.to_atom(UUID.uuid4()),
      project_task(job_id, page_id)
    )

    State.create(
      :task,
      String.to_atom(UUID.uuid4()),
      page_task(job_id, page_id)
    )
  end
  def build( id, %{ job_type: :annotate, project: project_id }) do

  end

  def project_task(job_id, page_id) do
    %{
      order: 1,
      job: job_id,
      status: :not_started,
      procedure:
      State.get(:page, page_id)
      |> Map.values()
      |> Enum.at(0)
      |> Map.get(:project)
      |> get_project_procedure()
    }
  end

  def page_task(job_id, page_id) do
    %{
      order: 2,
      job: job_id,
      status: :not_started,
      procedure:
      page_id
      |> get_page_procedure()
    }
  end

  def get_project_procedure(project_id) do
    State.get_all_related_data(:project, [project_id], :step)
    |> Enum.into([])
    |> Enum.sort(&Helpers.order(&1, &2, :asc))
    |> process_steps()
  end

  def get_page_procedure(page_id) do
    State.get_all_related_data(:page, [page_id], :step)
    |> add_page_annotations_steps(page_id)
    |> Enum.into([])
    |> Enum.sort(&Helpers.order(&1, &2, :asc))
    |> process_steps()
  end

  def process_steps(steps) do
    steps
    |> Enum.into([])
    |> Enum.reduce([], &convert_step/2)
  end

  def convert_step({ _key, step }, steps) do
    [ { step.step_type, step.args } | steps ]
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

end
