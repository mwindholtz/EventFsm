defmodule EventFsm.RulesTest do
  use EventFsm.EventFsmCase
  alias EventFsm.Rules

  @tag :capture_log
  test "transition_rules" do
    assert Rules.transition_rules()
  end

  describe "valid" do
    test "invalid event name" do
      rules = Rules.transition_rules()
      refute Rules.valid?(rules, :not_an_event)
    end

    test "valid event name" do
      rules = Rules.transition_rules()
      assert Rules.valid?(rules, :turned_once)
    end
  end

  describe "validate!" do
    test "invalid event name" do
      expected_message = "Invalid event (non_existing_event), not listed in Elixir.EventFsm.Rules"

      assert_raise RuntimeError, expected_message, fn ->
        # When
        Rules.validate!(:non_existing_event)
      end
    end

    test "valid event name" do
      assert Rules.validate!(:turned_once)
    end
  end
end
