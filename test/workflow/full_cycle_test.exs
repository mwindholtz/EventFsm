defmodule EventFsm.Workflow.FullCycleTest do
  use EventFsm.WorkflowCase
  alias EventFsm.Action, as: ShouldThen
  alias EventFsm.SequenceGenerator

  def workflow do
    [
      {coin_deposited(), [ShouldThen.unlock()]},
      {turned_once(), [ShouldThen.lock()]}
    ]
  end

  test "FullCycle", context do
    SequenceGenerator.gen_uml(workflow(), context.test)
  end

  test "matches fixture file" do    
    assert_steps_match_fixture(workflow(),  "FullCycle")  
  end

  @tag :capture_log
  test "run FullCycle" do
    assert_workflow(workflow(), 0)
  end
end
