defmodule EventFsm.Device.CoinAcceptorTest do
  use EventFsm.EventFsmCase

  alias EventFsm.Device.CoinAcceptor
  alias EventFsm.Evt

  describe "server process with reflector" do
    test "start link" do
      {:ok, _pid} = CoinAcceptor.start_link(CoinAcceptor.new())
    end

    test "init" do
      {:ok, _coin_acceptor} = CoinAcceptor.init(CoinAcceptor.new())
    end
  end

  describe "Handle Event" do
    test "success" do
      coin_acceptor = %CoinAcceptor{dispatcher: DispatcherReflector}
      assert {:noreply, ^coin_acceptor} = CoinAcceptor.handle_cast({:event, :coin}, coin_acceptor)
    end
  end

  describe "Accept Coin" do
    test "success" do
      coin_acceptor = %CoinAcceptor{dispatcher: DispatcherReflector}
      _mod_coin_acceptor = CoinAcceptor.accept_coin(coin_acceptor)
      # TODO: assert_receive  Evt.coin_deposited()
    end
  end
end
