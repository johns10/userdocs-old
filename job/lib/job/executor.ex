defmodule Job.Executor do

  alias Job.Helpers

  def execute(job_id) do
    { :ok, pid } = WebDriver.Server.start_link()

    State.get(:job, [job_id])
    |> update_status(:running, :job)
    |> get_tasks()
    |> prepare_tasks()
    |> execute_tasks(pid)
    |> update_status(:complete, :job)
  end

  def execute_tasks({ job, tasks }, pid) do
    tasks
    |> Enum.each(&execute_task(&1, pid))
    job
  end

  def execute_task(task, pid) do
    task
    |> update_status(:running, :task)
    |> map_to_tuple()
    |> execute_procedure(pid)
    |> update_status(:complete, :task)
  end

  def execute_procedure(task, pid) do
    :ok = WebDriver.execute_procedure(procedure(task), pid)
    task
  end

  def procedure({ _task_id, task }) do
    Map.get(task, :procedure)
  end

  def get_tasks(job) do
    {
      job,
      State.get_all_related_data( :job, [Map.keys(job) |> Enum.at(0)], :task )
    }
  end

  def prepare_tasks({ job, tasks }) do
    {
      job,
      tasks
      |> Enum.into([])
      |> Enum.sort(&Helpers.order(&1, &2, :desc))
    }
  end

  def update_status({ id, object }, status, type) do
    State.update(:task, id, Map.put(object, :status, status))
  end
  def update_status(object, status, type) do
    { id, object } = map_to_tuple(object)
    State.update(type, id, Map.put(object, :status, status))
  end

  def map_to_tuple(object) do
    Enum.into(object, [])
    |> Enum.at(0)
  end

end
