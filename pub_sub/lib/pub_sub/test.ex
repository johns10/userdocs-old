defmodule PubSub.PageList do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(_) do
    Phoenix.PubSub.subscribe(:page, "page_updates")
    {:ok, %{}}
  end

  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  def handle_info({ :create, id, object}, state) do
    IO.puts("Adding page with id: #{id}")

    state = state
    |> Map.put(id, object)

    { :noreply, state }
  end

  def handle_info({ :test, test }, state) do
    IO.puts("Received Message #{test}")
    {:noreply, state}
  end

  def handle_info({:return, product, quantity}, state) do
    IO.puts("Removing #{product} (#{quantity}) from shopping list")

    updated_state = state
      |> Map.update(product, 0, &(&1 - quantity))
      |> Enum.reject(fn({_, v}) -> v <= 0 end)
      |> Map.new

    {:noreply, updated_state}
  end
end
