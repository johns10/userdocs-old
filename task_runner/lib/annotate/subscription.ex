defmodule TaskRunner.Subscription do

  def handler( :create, id, %{ page: page_id, job_type: :annotate }, state ) do
    { :ok } = TaskRunner.Annotate.annotate_page(page_id)
    State.delete(:job, id)
  end

end
