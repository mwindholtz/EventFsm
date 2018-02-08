defmodule EventFsm.EngineTest do
  use EventFsm.EventFsmCase

  alias EventFsm.Evt
  alias EventFsm.Engine

  defmodule Stub do
    def event(context, event) do
      assert event.content == :no_evt_content
      assert context.state == :initial_state
      %{context | state: :next_state}
    end
  end

  def new_engine() do
    %Engine{state: :initial_state, transducer: Stub}
  end

  describe "handle_cast" do
    test ":event" do
      event = Evt.new(:coin_deposited)
      engine = new_engine()

      {status, _server} = Engine.handle_cast({:event, event}, engine)
      assert status == :noreply
    end
  end

  describe "process_event" do
    test "save state from event_context to/from engine.state" do
      event = Evt.new(:coin_deposited)
      engine = new_engine()
      engine = Engine.process_event(engine, event)
      assert engine.state == :next_state
    end
  end

  describe "real server" do
    # TODO 
    @tag [idle: true]
    test "reset" do
      Engine.start_link()
      :ok = Engine.reset()
    end

    @tag [idle: true]
    test "event" do
      event = Evt.new("turned_once")
      # When      
      :ok = Engine.event(event)
    end
  end
end
