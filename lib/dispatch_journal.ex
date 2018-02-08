defmodule EventFsm.DispatchJournal do
  @moduledoc """
    provides a gen_server that will save dispatch messages
  """
  use GenServer

  defstruct log: []

  # Client interface

  def new() do
    %__MODULE__{}
  end

  def reset(service_name \\ __MODULE__) do
    GenServer.call(service_name, {:reset})
  end

  def record(to, message, service_name \\ __MODULE__) do
    GenServer.call(service_name, {:record, {to, message}})
  end

  # Server Interface 

  def start_link(gateway \\ new(), service_name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, gateway, name: service_name)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call({:reset}, _from, _journal) do
    {:reply, :ok, new()}
  end

  def handle_call({:record, {to, message}}, _from, journal) do
    journal = log_it(journal, to, message)
    {:reply, :ok, journal}
  end

  # Implementation 

  def log_it(journal, to, {name, message}) do
    mod_log = [{to, {name, message}} | journal.log]
    %{journal | log: mod_log}
  end
end
