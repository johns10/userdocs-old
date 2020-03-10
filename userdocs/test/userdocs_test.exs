defmodule UserdocsTest do
  use ExUnit.Case
  doctest Userdocs

  require Logger

  import TestHelper
  test "creates a new content -> object, changeset" do
    assigns = TestHelper.test_data()
    assigns = Userdocs.Content.new(assigns)

    { id, changeset } = assigns.changesets.content
    |> Enum.at(0)

    object = Userdocs.Data.get_one(assigns, :content, id)

    Logger.debug(inspect(object))

    current_changeset = assigns.current_changesets.new_content

    assert(object.id != nil)
    assert(object.id == changeset.changes.id)
    #assert(assigns.current_changesets.new_version_pages[1] == page.id)
  end

  test "edits an existing project" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.content[1] == nil
    assigns = Userdocs.Content.edit(assigns, 1)
    changeset = assigns.changesets.content[1]
    assert changeset.changes.id == 1
  end

  test "saves a new content" do
    type = :content

    #It makes a new project, and gets its id + changeset
    assigns = TestHelper.test_data()
    assigns = Userdocs.Content.new(assigns)

    { id, changeset } = assigns.changesets[type]
    |> Enum.at(0)

    #It puts some new values on the changeset and applies it
    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("name", "Save Test")
      |> Map.put("description", "Description Test")
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, type, changeset.params)

    # It saves the project (should result in state change)
    Logger.debug("Here's the Content Params")
    Logger.debug(inspect(changeset.params))
    assigns = Userdocs.Content.save(assigns, changeset.params)
    # Simulates a subscription callback
    assigns = Userdocs.Subscription.handle_info({ type, :update, result }, assigns)
    # Validates that assigns has been updated with the state change
    object = Userdocs.Data.get_one(assigns, type, id)
    assert object.name == changeset.params["name"]
  end

  test "removes a new content" do
    type = :content
    assigns = TestHelper.test_data()
    assigns = Userdocs.Content.new(assigns)

    { id, changeset } = assigns.changesets[type]
    |> Enum.at(0)

    assigns = Userdocs.Content.remove(assigns, type, id)

    result = Enum.filter(
      assigns.project,
      fn(x) -> x.id == id end
    )

    assert result == []
  end

  test "validates a content" do
    assigns = TestHelper.test_data()
    form = TestHelper.content_form_existing()
    Userdocs.Content.validate(assigns, form, String.to_integer(form["id"]))
  end

  """
  test "creates a new annotation -> object, changeset" do
    assigns = TestHelper.test_data()
    assigns = Userdocs.Annotation.new(assigns, :page, 1)

    { id, changeset } = assigns.changesets.annotation
    |> Enum.at(0)

    annotation = Userdocs.Data.get_one(assigns, :annotation, id)

    Logger.debug(inspect(annotation))

    current_changeset = assigns.current_changesets.new_version_pages[1]

    assert(annotation.id != nil)
    assert(annotation.id == changeset.changes.id)
    #assert(assigns.current_changesets.new_version_pages[1] == page.id)
  end

  test "creates a new step -> object, changeset" do
    #Preconditions: Has a current version id
    assigns = TestHelper.test_data()
    assigns = Map.put(assigns, :current_version_id, 1)

    assigns = Userdocs.Step.new(assigns, :version, 1)

    { id, changeset } = assigns.changesets.step
    |> Enum.at(0)

    step = Userdocs.Data.get_one(assigns, :step, id)

    assert(step.id != nil)
    assert(step.id == changeset.changes.id)
  end


  test "saves an existing element" do
    type = :element

    assigns = TestHelper.test_data()
    form = TestHelper.element_form_existing()
    Logger.debug(inspect(form))

    page_id = String.to_integer(Map.get(form, "page_id"))

    assigns = Kernel.put_in(assigns,
      [ :ui, :page_element_forms, page_id ],
      Userdocs.Data.new_page_step_form()
    )

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, type, form)

    id = String.to_integer(form["id"])
    assigns = Userdocs.Element.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ type, :update, result }, assigns)
    object = Userdocs.Data.get_one(assigns, type, id)
    assert object.name == form["name"]
    Logger.debug(object.name)
  end

  test "saves a new element" do
    form = TestHelper.element_form_existing()
    assigns = TestHelper.test_data()
    assigns = Userdocs.Element.new(assigns, 1)

    changeset_id = assigns.current_changesets.new_page_elements[1]
    changeset = assigns.changesets.element[changeset_id]

    id = changeset.changes.id

    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("name", form["name"])
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :element, changeset.params)

    Logger.debug(inspect(result))
    assigns = Userdocs.Element.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ :element, :update, result }, assigns)
    element = Userdocs.Data.get_one(assigns, :element, id)
    assert element.name == form["name"]
  end

  test "creates a new element -> object, changeset" do
    assigns = TestHelper.test_data()
    assigns = Userdocs.Element.new(assigns, 1)

    { id, changeset } = assigns.changesets.element
    |> Enum.at(0)

    element = Userdocs.Data.get_one(assigns, :element, id)

    current_changeset = assigns.current_changesets.new_version_pages[1]

    assert(element.id != nil)
    assert(element.id == changeset.changes.id)
    assert(assigns.current_changesets.new_page_elements[1] == element.id)
    assert(assigns.ui.page_element_forms[1].mode == :new)
  end

  test "edits an existing element" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.element[1] == nil
    assigns = Userdocs.Element.edit(assigns, 1)
    changeset = assigns.changesets.element[1]
    assert changeset.changes.id == 1
  end

  test "validates an element" do
    assigns = TestHelper.test_data()
    form = TestHelper.page_form_existing()
    Userdocs.Page.validate(assigns, form, String.to_integer(form["id"]))
  end

  test "removes an existing element" do
    #Preconditions
    #Has assigns, changeset on assigns,
    type = :element

    assigns = TestHelper.test_data()
    object =
      Userdocs.Data.get_one(assigns, type, 1)
      |> Map.from_struct()

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, type, object)

    assigns = Kernel.put_in(assigns,
      [:changesets, type, 1], changeset)

    assigns = Userdocs.Element.remove(assigns, :project, 1)
    result = Map.put(result, :record_status, "removed")
    assigns = Userdocs.Subscription.handle_info({ type, :update, result }, assigns)
    updated_object = Userdocs.Data.get_one(assigns, type, 1)
    assert updated_object.record_status == "removed"
  end

  test "creates a new page -> object, changeset" do
    assigns = TestHelper.test_data()
    assigns = Map.put(assigns, :current_version_id, 1)
    assigns = Userdocs.Page.new(assigns, 1)

    { id, changeset } = assigns.changesets.page
    |> Enum.at(0)

    page = Userdocs.Data.get_one(assigns, :page, id)

    current_changeset = assigns.current_changesets.new_version_pages[1]

    assert(page.id != nil)
    assert(page.id == changeset.changes.id)
    assert(assigns.current_changesets.new_version_pages[1] == page.id)
  end

  test "edits an existing page" do
    assigns = TestHelper.test_data()
    assert assigns.changesets.page[1] == nil
    assigns = Userdocs.Page.edit(assigns, 1)
    changeset = assigns.changesets.page[1]
    assert changeset.changes.id == 1
  end

  test "saves an existing page" do
    type = :page

    assigns = TestHelper.test_data()
    form = TestHelper.page_form_existing()
    Logger.debug(inspect(form))

    { assigns, { :ok, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, type, form)

    id = String.to_integer(form["id"])
    assigns = Userdocs.Page.save(assigns, form)
    assigns = Userdocs.Subscription.handle_info({ type, :update, result }, assigns)
    object = Userdocs.Data.get_one(assigns, type, id)
    assert object.url == form["url"]
  end

  test "validates a  page" do
    assigns = TestHelper.test_data()
    form = TestHelper.page_form_existing()
    Userdocs.Page.validate(assigns, form, String.to_integer(form["id"]))
  end


  test "saves a new step" do
    #It makes a new project, and gets its id + changeset
    assigns = TestHelper.test_data()
    assigns = Map.put(assigns, :current_version_id, 1)
    assigns = Userdocs.Step.new(assigns, :version, 1)

    { id, changeset } = assigns.changesets.step
    |> Enum.at(0)

    #It puts some new values on the changeset and applies it
    changeset = Map.put(changeset, :params,
      changeset.params
      |> Map.put("order", "99999")
      |> Map.put("id", Integer.to_string(id))
    )

    { assigns, { _code, result }, changeset } =
      Userdocs.Changeset.apply_changeset(assigns, :step, changeset.params)

    # It saves the project (should result in state change)
    assigns = Userdocs.Step.save(assigns, Map.from_struct(result))
    # Simulates a subscription callback
    assigns = Userdocs.Subscription.handle_info({ :step, :update, result }, assigns)
    # Validates that assigns has been updated with the state change
    step = Userdocs.Data.get_one(assigns, :step, id)
    assert Integer.to_string(step.order) == changeset.params["order"]
  end

  test"moves a step" do
    # Make the drag data. Includes the parent id (version) and the id of the
    # Step to move.  The id will initially be the same as the step-id, which
    # is the id of the step represented by the element when the user starts
    # the action.
    drag = %{
      "parent-id" => "1",
      "source-id" => "2",
      "step-id" => "2",
      "parent-type" => "version"
    }
    assigns = TestHelper.test_data()
    version = Userdocs.Data.get_one(assigns, :version, 1)
    steps = Userdocs.Data.children(assigns, :version_id, version, :step)
    original_ids =
      Userdocs.Data.children(assigns, :version_id, version, :step)
      |> Enum.map(fn(step) -> step.id end)

    assigns = Userdocs.Step.reorder_start(assigns, drag, :drag)
    assigns = Userdocs.Step.reorder_drag(
      assigns,
      %{"step-id" => "2"},
      2
    )

    ids =
      Userdocs.Data.children(assigns, :version_id, version, :step)
      |> Enum.reduce(%{}, fn(step, acc) -> Map.put(acc, step.order, step.id) end)

    assert ids == %{1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5}

    assigns = Userdocs.Step.reorder_drag(assigns, %{"step-id" => "3"}, 3)

    ids =
      Userdocs.Data.children(assigns, :version_id, version, :step)
      |> Enum.reduce(%{}, fn(step, acc) -> Map.put(acc, step.order, step.id) end)

    assert ids == %{1 => 1, 2 => 3, 3 => 2, 4 => 4, 5 => 5}

    assigns = Userdocs.Step.reorder_drag(assigns, %{"step-id" => "1"}, 1)

    ids =
      Userdocs.Data.children(assigns, :version_id, version, :step)
      |> Enum.reduce(%{}, fn(step, acc) -> Map.put(acc, step.order, step.id) end)

    assert ids == %{1 => 2, 2 => 1, 3 => 3, 4 => 4, 5 => 5}

    assigns = Userdocs.Step.reorder_drag(assigns, %{"step-id" => "4"}, 4)

    ids =
      Userdocs.Data.children(assigns, :version_id, version, :step)
      |> Enum.reduce(%{}, fn(step, acc) -> Map.put(acc, step.order, step.id) end)

      assert ids == %{1 => 1, 2 => 3, 3 => 4, 4 => 2, 5 => 5}
  end

  test "validates a  step" do
    assigns = TestHelper.test_data()
    form = TestHelper.step_form_existing()
    Userdocs.Step.validate(assigns, form, String.to_integer(form["id"]))
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
