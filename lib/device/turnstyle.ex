defmodule EventFsm.Device.Turnstyle do
  use GenServer

  alias EventFsm.Dispatcher
  alias EventFsm.Evt

  defstruct dispatcher: Dispatcher

  alias __MODULE__
  @type t :: %__MODULE__{}

  def new(attrs \\ %{}) do
    Map.merge(%__MODULE__{}, attrs)
  end

  # Client interface

  def start_link(turnstyle = %Turnstyle{}, service_name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, turnstyle, name: service_name)
  end

  def cast_event(event) do
    GenServer.cast(__MODULE__, {:event, event})
  end

  # Server interface

  def init(turnstyle = %Turnstyle{}) do
    {:ok, turnstyle}
  end

  def handle_cast({:event, :coin}, turnstyle = %Turnstyle{}) do
    turnstyle
    {:noreply, turnstyle}
  end
end
