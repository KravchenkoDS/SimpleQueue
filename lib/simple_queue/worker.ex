defmodule SimpleQueue.Worker do
  # use GenServer

  use GenServer, restart: :transient

  def start_link(child) do
    GenServer.start_link(
      __MODULE__,
      child,
      name: via_tuple(child)
    )
  end

  def via_tuple(child) do
    IO.inspect("Worker: via_tuple")
    SimpleQueue.ProcessRegistry.via_tuple({__MODULE__, child})
  end

  @impl GenServer
  def init(_) do
    IO.inspect("Worker: init")
    work()
    initial_state = %{}
    {:ok, initial_state}
  end

  def work do
    IO.inspect("Worker: work")
    # raise "oops"

    Process.send_after(self(), :work, 5000)
  end

  @impl true
  def handle_info(:work, name) do
    IO.puts("Worker: handle_info")
    work()
    {:noreply, name}
  end

  def handle_info(:stop, child) do
    {:stop, :normal, child}
  end
end
