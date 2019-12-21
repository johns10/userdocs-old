defmodule TaskRunner do

  defdelegate create_job(job_type, data), to: TaskRunner.Annotate

end
