defmodule EventFsm.Device.CoinAcceptor do
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

  def start_link(coin_acceptor = %CoinAcceptor{}, service_name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, coin_acceptor, name: service_name)
  end

  def cast_event(event) do
    GenServer.cast(__MODULE__, {:event, event})
  end

  # Server interface

  def init(coin_acceptor = %CoinAcceptor{}) do
    {:ok, coin_acceptor}
  end

  def handle_cast({:event, :coin}, coin_acceptor = %CoinAcceptor{}) do
    coin_acceptor
    |> accept_coin()

    {:noreply, coin_acceptor}
  end

  # Implementation

  def accept_coin(coin_acceptor) do
    # TODO: Evt.coin_deposited() |> coin_acceptor.dispatcher().cast_to_engine()
    coin_acceptor
  end
end
