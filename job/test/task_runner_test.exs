defmodule JobTest do
  use ExUnit.Case
  doctest Job

  """

  test "Get Project Data returns project data" do
    Job.Annotate.get_project_data(:funnel_cloud)
  end

  test "Get project procedure returns project" do
    Job.Annotate.get_project_procedure(:funnel_cloud)
  end

  test "Get annotation procedure returns steps" do
    Job.Annotate.add_page_annotations_steps(%{key: :value}, :at_a_glance)
  end

  test "Get Page Procedure returns procedure" do
    Job.Annotate.get_page_procedure(:at_a_glance)
  end

  """

  test "Annotate page generates screenshot" do
    Job.Annotate.annotate_page(:test_page)
  end
end
