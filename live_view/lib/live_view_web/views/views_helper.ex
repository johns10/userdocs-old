defmodule LiveViewWeb.Helpers do

  def get(type, keys) do
    State.get(type, keys, [])
  end

end
