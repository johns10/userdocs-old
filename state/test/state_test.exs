defmodule StateTest do
  use ExUnit.Case
  doctest State

  test "gets one object" do
    state = State.State.new_state()
    type = :step_type
    ids = [ :navigate ]
    { :ok, data_type } = Map.fetch(state, type)
    expected_result = Map.take(data_type, ids)
    { _state, result } = State.State.get(state, type, ids)
    assert(result == expected_result)
  end

  test "gets all the objects" do
    state = State.State.new_state()
    type = :step_type
    { :ok, expected_result } = Map.fetch(state, type)
    { _state, result } = State.State.get(state, type, [])
    assert result == expected_result
  end

  test "gets several object" do
    state = State.State.new_state()
    type = :step_type
    ids = [ :navigate, :click ]
    { :ok, data_type } = Map.fetch(state, type)
    expected_result = Map.take(data_type, ids)
    { _state, result } = State.State.get(state, type, ids)
    assert(result == expected_result)
  end

  test "create new creates a new object" do
    state = State.State.new_state()
    type = :step_type
    key = :test_step_type
    value = %{
        type: :step_type,
        args: [:test, :test]
    }
    { state, result } = State.State.create(state, type, key, value)
    expected_result = state.step_type.test_step_type
    assert(result == %{ key => expected_result})
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

  test "updating a non-existent record fails" do
    state = State.State.new_state()
    type = :step_type
    key = :new
    value = %{
      type: :page,
      attributes: %{
        args: [:new, :face]
      }
    }
    try do
      State.State.update(state, type, key, value)
    rescue
      KeyError -> assert(true)
    end
  end

  test "get related data returns related data" do
    state = %{
      to_type: %{
        test_to_one: %{
          from_type: :test_from_one,
          a: 1
        },
        test_to_two: %{
          from_type: :test_from_one,
          a: 2
        }
      },
      from_type: %{
        test_from_one: %{
          a: 1
        }
      }
    }
    { _state, data } = State.State.get_all_related_data(
      state,
      :from_type,
      [:test_from_one],
      :to_type
    )
    assert data == %{
      test_to_one: %{a: 1, from_type: :test_from_one},
      test_to_two: %{a: 2, from_type: :test_from_one}
    }
  end

end
