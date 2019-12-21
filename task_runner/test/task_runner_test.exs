defmodule TaskRunnerTest do
  use ExUnit.Case
  doctest TaskRunner

  """

  test "Get Project Data returns project data" do
    TaskRunner.Annotate.get_project_data(:funnel_cloud)
  end

  test "Get project procedure returns project" do
    TaskRunner.Annotate.get_project_procedure(:funnel_cloud)
  end

  test "Get annotation procedure returns steps" do
    TaskRunner.Annotate.add_page_annotations_steps(%{key: :value}, :at_a_glance)
  end

  test "Get Page Procedure returns procedure" do
    TaskRunner.Annotate.get_page_procedure(:at_a_glance)
  end

  """

  test "Annotate page generates screenshot" do
    TaskRunner.Annotate.annotate_page(:test_page)
  end
end
