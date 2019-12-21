defmodule StateHelpersTest do
  use ExUnit.Case
  doctest State
"""
  test "get_all_relationship data gets the right data" do
    from_ids = [:default, :default2]
    from_type = :page
    to_type = :step
    expected_result = %{
      four: %{
        args: %{
          selector: "/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']"
        },
        page: :default2,
        step_type: :wait,
        strategy: :xpath,
        type: :step
      },
      one: %{
        args: %{url: "www.google.com"},
        page: :default,
        step_type: :navigate,
        strategy: :xpath,
        type: :step
      },
      three: %{
        args: %{url: "www.google.com"},
        page: :default2,
        step_type: :wait,
        strategy: :xpath,
        type: :step
      },
      two: %{
        args: %{
          selector: "/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']"
        },
        page: :default,
        step_type: :wait,
        strategy: :xpath,
        type: :step
      }
    }
    state = State.State.new_state()
    { _state, result } = State.State.get_all_related_data(state, from_type, from_ids, to_type)
    assert result == expected_result
  end

  test "get_reverse_relationship returns related objects" do
    id = :default
    object = %{
      type: :page,
      url: "www.google.com",
      procedure: :default_procedure
      }
    expected_result = %{
      one: %{
        args: %{url: "www.google.com"},
        page: :default,
        step_type: :navigate,
        strategy: :xpath,
        type: :step
      },
      two: %{
        args: %{
          selector: "/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']"
        },
        page: :default,
        step_type: :wait,
        strategy: :xpath,
        type: :step
      }
    }
    state = State.State.new_state()
    result = State.State.get_reverse_relationship(state, { id, object }, :step)
    assert(result == expected_result)
  end

  test "get_forward_ids returns object with forward relationship attached" do
    id = :default
    object = %{
      type: :page,
      url: "www.google.com",
      procedure: :default_procedure
      }
    expected_result = %{
      procedure: :default_procedure,
      step: [:two, :one],
      type: :page,
      url: "www.google.com"
    }
    state = State.State.new_state()
    result = State.State.get_forward_ids(state, { id, object }, :step)
    assert(result == expected_result)
  end



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
"""


end
