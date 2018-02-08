defmodule EventFsm.EventContextTest do
  use EventFsm.EventFsmCase

  alias EventFsm.EventContext

  def engine, do: %{rules: %{}, state: :locked}

  test "new" do
    empty_rules = %{}
    expected = %EventContext{rules: empty_rules, state: :locked}
    # When 
    actual = EventContext.new(engine())
    # Then
    assert actual == expected
  end

  describe "add_actions" do
    test "degenerate" do
      context =
        EventContext.new(engine())
        |> EventContext.add_actions([])

      assert context.actions == []
    end

    test "simple" do
      context =
        EventContext.new(engine())
        |> EventContext.add_actions([:a])

      assert context.actions == [:a]
    end

    test "flatten" do
      context =
        EventContext.new(engine())
        |> EventContext.add_actions([:a, [:b]])

      assert context.actions == [:a, :b]
    end
  end
end
