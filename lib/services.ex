defmodule EventFsm.Services do
  def engine, do: EventFsm.Device.Engine
  def turnstyle, do: EventFsm.Device.Turnstyle
  def indicator, do: EventFsm.Device.Indicator
  def coin_acceptor, do: EventFsm.Device.CoinAcceptor
end
