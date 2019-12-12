defmodule TaskRunnerTest do
  use ExUnit.Case
  doctest TaskRunner

  test "Get Project Data returns project data" do
    TaskRunner.Annotate.get_project_data(:funnel_cloud)
  end

  test "Get Page Procedure returns procedure" do
    TaskRunner.Annotate.get_page_procedure(:at_a_glance)
  end
end
