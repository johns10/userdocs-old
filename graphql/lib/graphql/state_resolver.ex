defmodule Graphql.State.StateResolver do

  def new(args, _info) do
    #IO.puts("In new state")
    pid = State.new()
    { :ok, %{ pid: Kernel.inspect(pid)} }
  end

  def find(%{id: id}, _info) do
    { :ok }
  end
end
