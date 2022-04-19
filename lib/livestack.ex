defmodule LiveStack do
  use GenServer

  def start_link(base_stack \\ []) do
    GenServer.start_link(__MODULE__, base_stack, name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, {:status})
  end

  def pop do
    GenServer.call(__MODULE__, {:pop})
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def init(base_stack) do
    {:ok, base_stack}
  end

  def handle_call({:status}, _from, stack) do
    {:reply, stack, stack}
  end

  def handle_call({:pop}, _from, stack) do
    new_stack = case stack do
      [] -> []
      [_head | tail] -> tail
    end
    Phoenix.PubSub.broadcast Consensus.PubSub, "live_stack", :stack_updated
    {:reply, new_stack, new_stack}
  end

  def handle_cast({:push, item}, stack) do
    new_stack = [item|stack]
    Phoenix.PubSub.broadcast Consensus.PubSub, "live_stack", :stack_updated
    {:noreply, new_stack}
  end

end
