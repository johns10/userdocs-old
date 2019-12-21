defmodule Job do

  defdelegate create_job(job_type, data), to: Job.Annotate

end
