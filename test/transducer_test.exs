defmodule EventFsm.TransducerTest do
  use EventFsm.EventFsmCase
  alias EventFsm.Evt
  alias EventFsm.Transducer
  alias EventFsm.EventContext
  # defined at bottom of this file.
  alias EventFsm.TransducerTest.Stub

  def rules_engine do
    %{rules: EventFsm.Rules.transition_rules(), state: :locked}
  end

  def connect do
    context = %EventContext{rules: Stub.transition_rules()}
    connect_evt = Evt.new(:turned_once)
    context = Transducer.generate_actions(context, connect_evt)
    assert context.state == :idle
    context
  end

  describe "connect with rules_engine" do
    test " connect -> pending" do
      event = Evt.new(:turned_once, {:creds, :creds})
      context = EventContext.new(rules_engine())
      context = Transducer.event(context, event)
      assert context.state == :locked
    end

    test " store creds" do
      event = Evt.new(:turned_once, {:creds, :creds})
      context = EventContext.new(rules_engine())
      context = Transducer.event(context, event)
      assert_action_names(context.actions, [:store])
    end
  end

  # rules_engine

  describe "add coin" do
    test "tor event ignored b/c its out of sequence" do
      context = %EventContext{rules: Stub.transition_rules()}
      evt = Evt.new(:coin_deposited)
      context = Transducer.generate_actions(context, evt)
      assert context.state == :unlocked
      assert_action_names(context.actions, [])
    end
  end

  # generate_actions

  def assert_action_names(actions, expected_names) do
    actual_names = Enum.map(actions, fn x -> x.name end)

    assert actual_names == expected_names,
           "expected:#{inspect(expected_names)}\nactual:  #{inspect(actual_names)}"
  end

  defmodule Stub do
    def transition_rules() do
      %{
        {:locked, :coin_deposited} => {:unlocked, []},
        #       { :unlocked, :turned_once}      => { :locked,   [ Action.term(:display_order_form) ] },
        {:any, :invalid_message} => {:no_change, []}
      }
    end
  end
end
