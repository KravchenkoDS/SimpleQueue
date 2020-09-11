defmodule SimpleQueue.ProcessRegistry do
  import SimpleQueue.Worker

  def start_link do
    IO.inspect("ProcessRegistry: start_link")
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def get_child(child) when is_binary(child) do
    IO.inspect("ProcessRegistry: child")
    Registry.whereis_name({__MODULE__, {SimpleQueue.Worker, child}})
  end

  def via_tuple(key) do
    IO.inspect("ProcessRegistry: via_tuple")
    {:via, Registry, {__MODULE__, key}}
  end

  def child_spec(_) do
    IO.inspect("ProcessRegistry: child_spec")

    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
