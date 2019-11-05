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


end
