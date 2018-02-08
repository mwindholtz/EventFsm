defmodule EventFsm.Device.Indicator do
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

  def start_link(indicator = %Indicator{}, service_name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, indicator, name: service_name)
  end

  def cast_event(event) do
    GenServer.cast(__MODULE__, {:event, event})
  end

  # Server interface

  def init(indicator = %Indicator{}) do
    {:ok, indicator}
  end

  def handle_cast({:event, _light_color}, indicator = %Indicator{}) do
    indicator
    {:noreply, indicator}
  end

  # Implementation 

  def green_light(indicator = %Indicator{}) do
    indicator
  end

  def red_light(indicator = %Indicator{}) do
    indicator
  end
end
