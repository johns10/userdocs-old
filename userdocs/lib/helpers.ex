defmodule Userdocs.Helpers do

  def provisional_id() do
    :rand.uniform(10000000) + 10000000
  end

  def to_map({ assigns, object_struct }) do
    { assigns, Map.from_struct(object_struct) }
  end

  def put_in_assigns({ assigns, value }, path) do
    Kernel.put_in(assigns, path, value)
  end

end
