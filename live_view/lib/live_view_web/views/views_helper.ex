defmodule LiveViewWeb.Helpers do

  def get(type, keys) do
    result = State.get(type, keys, [])
  end

end
