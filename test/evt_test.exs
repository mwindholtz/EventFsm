defmodule EventFsm.EvtTest do
  use EventFsm.EventFsmCase
  alias EventFsm.Evt

  describe "initialization" do
    test "new" do
      event = Evt.new("turned_once")
      assert event.name == :turned_once
      assert event.content == :no_evt_content
    end

    test "struct" do
      event = %Evt{name: "turned_once"}
      assert event.name == "turned_once"
      assert event.content == :no_evt_content
    end

    test "journalable protocol" do
      event = Evt.new("turned_once")

      assert EventFsm.Journalable.to_entry(event) == %{
               name: :turned_once,
               content: :no_evt_content
             }
    end

    test "event with content" do
      expected = %Evt{name: :coin_deposited, content: {:coin, 5}, source: "CoinAcceptor"}
      actual = Evt.coin_acceptor(:coin_deposited, {:coin, 5})
      assert expected == actual
    end
  end
end
