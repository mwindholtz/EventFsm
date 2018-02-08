defmodule EventFsm.Dispatcher do
  @moduledoc """
    Co-ordinates sending messages to the devices and engine
    (1) Engine, (2) Indicator, (3) Turnstyle, (4) CoinAcceptor
  """
  alias EventFsm.Evt
  alias EventFsm.DispatchJournal
  alias EventFsm.Services

  # --- send functions ----

  def cast_to_engine(event = %Evt{}, services \\ Services) do
    cast_to(services.engine(), {:event, event})
  end

  def cast_to_indicator(event = %Evt{}, services \\ Services) do
    cast_to(services.indicator(), {:event, event})
  end

  def cast_to_turnstyle(event = %Evt{}, services \\ Services) do
    cast_to(services.turnstyle(), {:event, event})
  end

  def cast_to_coin_acceptor(event = %Evt{}, services \\ Services) do
    cast_to(services.coin_acceptor(), {:event, event})
  end

  # --- Implementaion  

  defp cast_to(handle, term) do
    DispatchJournal.record(handle, term)
    GenServer.cast(handle, term)
  end
end
