defmodule StateHelpersTest do
  use ExUnit.Case
  doctest State

  test "get_relationship_data returns related data when requested" do
    state = State.State.new_state()
    type = :step_type
    related_ids = [:navigate, :fill_field]
    result = State.State.get_relationship_data(state, type, related_ids, true)
    { :ok, data_type } = Map.fetch(state, type)
    expected_result = Map.take(data_type, related_ids)
    assert(result == expected_result)
  end

  test "get_relationship_data returns id's when not related not requested" do
    state = State.State.new_state()
    type = :step_type
    related_ids = [:navigate, :fill_field]
    result = State.State.get_relationship_data(state, type, related_ids, false)
    assert(result == related_ids)
  end


  test "get_relationships returns object with related data" do
    state = State.State.new_state()
    type = :procedure
    { :ok, data } = Map.fetch(state, type)
    includes = [:page]
    expected_result =  expected_result = [ default_procedure: %{ attributes: %{name: "Procedure Name"}, relationships: [ page: %{ default: %{ attributes: %{url: "www.google.com"}, relationships: %{procedure: :default_procedure}, type: :page } }, step: [:default] ], type: :procedure }, default_procedure_2: %{ attributes: %{name: "Procedure Name 2"}, relationships: [ page: %{ default: %{ attributes: %{url: "www.google.com"}, relationships: %{procedure: :default_procedure}, type: :page } }, step: [:default, :default2] ], type: :procedure } ]
    { _state, result } = State.State.get_relationships({ state, data, includes })
    assert(result == expected_result)
  end

  test "gets all the objects" do
    state = State.State.new_state()
    type = :step_type
    { :ok, expected_result } = Map.fetch(state, type)
    { _state, result } = State.State.get(state, type, [], [])
    assert result == expected_result
  end

  test "gets several object" do
    state = State.State.new_state()
    type = :step_type
    ids = [ :navigate, :click ]
    { :ok, data_type } = Map.fetch(state, type)
    expected_result = Map.take(data_type, ids)
    { _state, result } = State.State.get(state, type, ids, [])
    assert(result == expected_result)
  end

  test "gets one object" do
    state = State.State.new_state()
    type = :step_type
    ids = [ :navigate ]
    { :ok, data_type } = Map.fetch(state, type)
    expected_result = Map.take(data_type, ids)
    { _state, result } = State.State.get(state, type, ids, [])
    assert(result == expected_result)
  end

  test "gets one object with relations" do
    state = State.State.new_state()
    type = :procedure
    ids = [ :default_procedure ]
    includes = [ :page, :step ]
    { :ok, _data_type } = Map.fetch(state, type)
    { _state, result } = State.State.get(state, type, ids, includes)
    expected_result = [ default_procedure: %{ attributes: %{name: "Procedure Name"}, relationships: [ page: %{ default: %{ attributes: %{url: "www.google.com"}, relationships: %{procedure: :default_procedure}, type: :page } }, step: %{ default: %{ attributes: %{ args: [ selector: "/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']" ], strategy: :xpath }, relationships: %{step_type: :wait}, type: :step } } ], type: :procedure } ]
    assert(result == expected_result)
  end

  test "create new creates a new object" do
    state = State.State.new_state()
    type = :step_type
    key = :test_step_type
    value = %{
        type: :step_type,
        attributes: %{
          type: :test,
          args: [:test, :test]
      }
    }
    { _state, result } = State.State.create(state, type, key, value)
    assert(%{ key => value } == result)
  end

  test "update updates an object" do
    state = State.State.new_state()
    type = :step_type
    key = :wait
    value = %{
      type: :test,
      attributes: %{
        args: [:face, :test]
      }
    }
    { state, _result } = State.State.update(state, type, key, value)
    { :ok, step_types } = Map.fetch(state, type)
    assert(value == step_types[key])
  end

  test "delete deletes an object" do
    state = State.State.new_state()
    type = :step_type
    key = :wait
    state = State.State.delete(state, type, key)
    { :ok, step_types } = Map.fetch(state, type)
    assert(step_types[key] == nil)
  end


  '''
  test "includes related data" do
    object = %{
      foo: "bar",
      relationships: %{
        page: [ :default ],
        procedure: %{ face: "time", foo: "bar"},
        step_type: :blank
      }
    }
    relationship_types = [ :page, :procedure, :step_type ]
    result = State.Helpers.include( object, relationship_types )
    assert result == { object,
        %{
        object2: [1, 2, 3],
        object3: %{ face: "time", foo: "bar"},
        object4: :blank
      }
    }
  end

  test "gets" do
    pid = State.new_state()
    thing = State.get(pid, :procedure, [:default_procedure], [:step, :page])
    IO.inspect(thing)
  end

  test "returns related objects" do
    related = %{
      a: 1,
      b: 2,
      c: 3,
      d: 4
    }
    indexes = [ :a, :c ]
    result = State.Helpers.retreive_related_data({ indexes, related })
    assert(result == [1, 3])
  end

  test "get related data returns map with related data" do
    state = State.State.new_state()
    keys = %{
      page: [:default],
      step_type: [:navigate, :fill_field]
    }
    includes = [:page, :step_type]
    { state, result } = State.State.get_related_data({ state, keys, includes })
    #IO.inspect(result)
  end

  test "get_data_type returns entire type" do
    state = State.State.new_state()
    type = :step_type
    keys = []
    includes = []
    expected_result = state.step_type
    { state, result, keys, includes } = State.State.get_data_type({ state, type, keys, includes })
    IO.inspect(result)
    assert(result == expected_result)
  end

  test "get_by_ids filters result" do
    state = State.State.new_state()
    data = state.procedure
    keys = [:default_procedure, :default_procedure_2]
    includes = []
    expected_result = Map.take(state.procedure, keys)
    { state, result, includes } = State.State.get_by_ids({ state, data, keys, includes })
    IO.inspect(result)
    assert(result == expected_result)
  end

  test "get includes returns results" do
    state = State.State.new_state()
    data = Enum.into(Map.take(state.procedure, [:default_procedure]), [])
    #IO.inspect(data)
    includes = [:page, :step]
    State.State.get_includes({ state, data, includes })
    #IO.inspect(related)
  end

  test "update_relationship returns relationship data" do
    state = State.State.new_state()
    relationship = { :step, [:default, :default2] }
    data_to_include = %{
      step: state.step
    }
    object = state.procedure.default_procedure
    #IO.inspect(relationship)
    #IO.inspect(data_to_include)
    State.State.update_relationship({ state, object, relationship, data_to_include })
    #|> IO.inspect
  end
  '''

end
