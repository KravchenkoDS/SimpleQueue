defmodule SimpleQueue.SimpleQueueSupervisor do
  use DynamicSupervisor

  import SimpleQueue.Worker

  def start_link(init_arg) do
    IO.inspect("SimpleQueueSupervisor: start_link")
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # @impl DynamicSupervisor
  @impl true
  def init(_init_arg) do
    IO.inspect("SimpleQueueSupervisor: init")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def handle_info({:EXIT, from, reason}, state) do
    IO.puts("Exit pid: #{inspect(from)} reason: #{inspect(reason)}")
    child = state[from]
    {:ok, pid} = child.start_link()
    {:noreply, Map.put(state, pid, child)}
  end

  def start_children do
    IO.inspect("SimpleQueueSupervisor: start_children")

    for child <- [:child1, :child2, :child3] do
      {:ok, _pid} = start_child(child)
    end

    :ok
  end

  def start_child(child) do
    IO.inspect("SimpleQueueSupervisor: start_child")

    DynamicSupervisor.start_child(
      __MODULE__,
      {SimpleQueue.Worker, child}
    )
  end

  def find_child(child) do
    case start_child(child) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  # Terminate a child process and remove it from supervision
  def remove_child(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def delete_child(pid) do
    DynamicSupervisor.delete_child(__MODULE__, pid)
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  def stop_child() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, worker, _, _} -> worker end)
    |> Enum.random()
    |> Process.send(:stop, [])
  end
end
