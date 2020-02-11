defmodule UserdocsTest do
  use ExUnit.Case
  doctest Userdocs

  require Logger

  import TestHelper

  test"moves a step" do
    assigns = TestHelper.test_data()
    version = Userdocs.Data.get_one(assigns, :version, 1)
    steps = Userdocs.Data.children(assigns, :version_id, version, :step)
    assigns = Userdocs.Step.reorder_start(assigns, step_form_existing(), :drag)
    Logger.debug(inspect(assigns.drag))
  end

  """
  test "validates a  step" do
    assigns = TestHelper.test_data()
    form = TestHelper.step_form_existing()
    Userdocs.Step.validate(assigns, form, String.to_integer(form["id"]))
  end

  test "creates a new step -> object, changeset" do
    #Preconditions: Has a current version id
    assigns = TestHelper.test_data()
    assigns = Map.put(assigns, :current_version_id, 1)

    assigns = Userdocs.Step.new(assigns, 1)

    { id, changeset } = assigns.changesets.step
    |> Enum.at(0)

    step = Userdocs.Data.get_one(assigns, :step, id)

    assert(step.id != nil)
    assert(step.id == changeset.changes.id)
  end

  test "edits an existing step" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.step[1] == nil
    assigns = Userdocs.Step.edit(assigns, 1)
    changeset = assigns.changesets.step[1]

    object = Userdocs.Data.get_one(assigns, :step, 1)
    arg_changeset = Enum.at(changeset.changes.args, 0)
    changeset_value = arg_changeset.changes.value

    arg = Enum.at(object.args, 0)
    object_value = arg.value

    assert changeset.changes.id == 1
    assert changeset_value == object_value
  end

  test "saves an existing step" do
    assigns = TestHelper.test_data()
    form = TestHelper.step_form_existing()

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :step, form)

    id = String.to_integer(form["id"])
    assigns = Userdocs.Step.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ :step, :update, result }, assigns)

    object = Userdocs.Data.get_one(assigns, :step, id)
    arg = Enum.at(object.args, 0)
    object_value = arg.value

    arg_changeset = Enum.at(changeset.changes.args, 0)
    changeset_value = arg_changeset.changes.value

    assert changeset_value == object_value
  end

  test "saves a new step" do
    #It makes a new project, and gets its id + changeset
    assigns = Userdocs.Step.new(TestHelper.test_data(), 1)

    { id, changeset } = assigns.changesets.step
    |> Enum.at(0)

    #It puts some new values on the changeset and applies it
    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("name", "Save Test")
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :step, changeset.params)

    # It saves the project (should result in state change)
    assigns = Userdocs.Step.save(assigns, changeset.params)
    # Simulates a subscription callback
    assigns = Userdocs.Subscription.handle_info({ :step, :update, result }, assigns)
    # Validates that assigns has been updated with the state change
    step = Userdocs.Data.get_one(assigns, :step, id)
    assert step.name == changeset.params["name"]
  end


  test "creates a new project -> object, changeset" do
    assigns = Userdocs.Project.new(TestHelper.test_data())

    { id, changeset } = assigns.changesets.project
    |> Enum.at(0)

    project = Userdocs.Data.get_one(assigns, :project, id)

    assert(project.id != nil)
    assert(project.id == changeset.changes.id)
  end

  test "creates a new version -> object, changeset" do
    assigns = Userdocs.Version.new(TestHelper.test_data(), 1)

    { id, changeset } = assigns.changesets.version
    |> Enum.at(0)

    version = Userdocs.Data.get_one(assigns, :version, id)

    assert(version.id != nil)
    assert(version.id == changeset.changes.id)
  end

  test "edits an existing project" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.project[1] == nil
    assigns = Userdocs.Project.edit(assigns, 1)
    changeset = assigns.changesets.project[1]
    assert changeset.changes.id == 1
  end

  test "edits an existing version" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.version[1] == nil
    assigns = Userdocs.Version.edit(assigns, 1)
    changeset = assigns.changesets.version[1]
    assert changeset.changes.id == 1
  end

  test "edits a new project" do
    assigns = Userdocs.Project.new(TestHelper.test_data())

    { id, changeset } = assigns.changesets.project
    |> Enum.at(0)

    assigns = Userdocs.Project.edit(assigns, id)
    changeset = assigns.changesets.project[id]
    assert changeset.changes.id == id
  end

  test "saves an existing project" do
    assigns = TestHelper.test_data()
    form = TestHelper.project_form_1()

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :project, form)

    id = String.to_integer(form["id"])
    assigns = Userdocs.Project.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ :project, :update, result }, assigns)
    project = Userdocs.Data.get_one(assigns, :project, id)
    assert project.name == form["name"]
  end

  test "saves an existing version" do
    assigns = TestHelper.test_data()
    form = TestHelper.version_form_existing()

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :version, form)

    id = String.to_integer(form["id"])
    assigns = Userdocs.Version.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ :version, :update, result }, assigns)
    version = Userdocs.Data.get_one(assigns, :version, id)
    assert version.name == form["name"]
  end

  test "saves a new project" do
    #It makes a new project, and gets its id + changeset
    assigns = Userdocs.Project.new(TestHelper.test_data())

    { id, changeset } = assigns.changesets.project
    |> Enum.at(0)

    #It puts some new values on the changeset and applies it
    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("name", "Save Test")
      |> Map.put("project_type", "Web")
      |> Map.put("base_url", "www.savetest2.com")
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :project, changeset.params)

    # It saves the project (should result in state change)
    assigns = Userdocs.Project.save(assigns, changeset.params)
    # Simulates a subscription callback
    assigns = Userdocs.Subscription.handle_info({ :project, :update, result }, assigns)
    # Validates that assigns has been updated with the state change
    project = Userdocs.Data.get_one(assigns, :project, id)
    assert project.name == changeset.params["name"]
  end

  test "saves a new version" do
    assigns = Userdocs.Version.new(TestHelper.test_data(), 1)

    Logger.debug(inspect(assigns.changesets.version))

    { id, changeset } = assigns.changesets.version
    |> Enum.at(0)

    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("name", "0.0")
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :version, changeset.params)

    assigns = Userdocs.Version.save(assigns, changeset.params)
    assigns = Userdocs.Subscription.handle_info({ :version, :update, result }, assigns)
    version = Userdocs.Data.get_one(assigns, :version, id)
    assert version.name == changeset.params["name"]
  end
  test "removes an existing project" do
    #Preconditions
    #Has assigns, changeset on assigns,
    assigns = TestHelper.test_data()
    project =
      Userdocs.Data.get_one(assigns, :project, 1)
      |> Map.from_struct()

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :project, project)

    assigns = Kernel.put_in(assigns,
      [:changesets, :project, 1], changeset)

    assigns = Userdocs.Project.remove(assigns, :project, 1)
    result = Map.put(result, :record_status, "removed")
    assigns = Userdocs.Subscription.handle_info({ :project, :update, result }, assigns)
    updated_project = Userdocs.Data.get_one(assigns, :project, 1)
    assert updated_project.record_status == "removed"
  end

  test "removes an existing version" do
    #Preconditions
    #Has assigns, changeset on assigns,
    assigns = TestHelper.test_data()
    version =
      Userdocs.Data.get_one(assigns, :version, 1)
      |> Map.from_struct()

    Logger.debug("Tester Version")
    Logger.debug(inspect(version))

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :version, version)

    Logger.debug("Tester Changeset")
    Logger.debug(inspect(changeset))

    assigns = Kernel.put_in(assigns,
      [:changesets, :version, 1], changeset)

    assigns = Userdocs.Version.remove(assigns, :version, 1)
    result = Map.put(result, :record_status, "removed")
    assigns = Userdocs.Subscription.handle_info({ :version, :update, result }, assigns)
    updated_version = Userdocs.Data.get_one(assigns, :version, 1)
    assert updated_version.record_status == "removed"
  end

  test "removes a new project" do
    #It makes a new project, and gets its id + changeset
    assigns = Userdocs.Project.new(TestHelper.test_data())

    { id, changeset } = assigns.changesets.project
    |> Enum.at(0)

    #It removes it
    assigns= Userdocs.Project.remove(assigns, :project, id)

    #It checks that the record was removed from the socket
    result = Enum.filter(
      assigns.project,
      fn(x) -> x.id == id end
    )

    assert result == []
  end

  test "removes a new version" do
    #It makes a new project, and gets its id + changeset
    assigns = Userdocs.Version.new(TestHelper.test_data(), 1)

    { id, changeset } = assigns.changesets.version
    |> Enum.at(0)

    #It removes it
    assigns= Userdocs.Version.remove(assigns, :version, id)

    #It checks that the record was removed from the socket
    result = Enum.filter(
      assigns.version,
      fn(x) -> x.id == id end
    )

    assert result == []
  end
"""


end
