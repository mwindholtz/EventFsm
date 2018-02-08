defmodule EventFsm.Device.IndicatorTest do
  use EventFsm.EventFsmCase

  alias EventFsm.Device.Indicator
  alias EventFsm.Evt

  describe "server process with reflector" do
    test "start link" do
      {:ok, _pid} = Indicator.start_link(Indicator.new())
    end

    test "init" do
      {:ok, _indicator} = Indicator.init(Indicator.new())
    end
  end

  describe "Handle Event" do
    test "red_light" do
      indicator = %Indicator{dispatcher: DispatcherReflector}
      assert {:noreply, ^indicator} = Indicator.handle_cast({:event, :red_light}, indicator)
    end

    test "green_light" do
      indicator = %Indicator{dispatcher: DispatcherReflector}
      assert {:noreply, ^indicator} = Indicator.handle_cast({:event, :green_light}, indicator)
    end
  end

  describe "Set green_light" do
    test "success" do
      indicator = %Indicator{dispatcher: DispatcherReflector}
      _mod_indicator = Indicator.green_light(indicator)
      # TODO: assert_receive  Evt.coin_deposited()
    end
  end
end
