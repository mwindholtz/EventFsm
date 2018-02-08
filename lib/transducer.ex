defmodule EventFsm.Transducer do
  @moduledoc """
  Given an event_context and an event
  returns event_context with next_state and actions
  """
  alias EventFsm.Evt
  alias EventFsm.EventContext
  alias EventFsm.Action

  @nop {:nop, []}

  @doc """
    Given an EventContext 
    If there is a content tuple in the event, prepend actions list with a store-action and the tuple
    Add the events to the context journal in the EventContext

    Returns an EventContext with action list and updated journal
  """
  def event(context = %EventContext{}, event = %Evt{}) do
    context
    |> EventContext.add_actions(optional_store(event))
    |> generate_actions(event)
    |> EventContext.add_events(event.name)
  end

  @doc """
    Given an EventContext 
        
    Returns an EventContext with action list and updated journal
  """
  def generate_actions(
        context = %EventContext{rules: transition_rules, state: current_state},
        evt = %Evt{name: evt_name}
      ) do
    {next_state, actions} =
      case instructions(current_state, transition_rules, evt_name) do
        @nop -> any_state_instructions(current_state, transition_rules, evt_name)
        found -> found
      end

    context =
      context
      |> EventContext.add_actions(actions)
      |> EventContext.transition(evt_name, current_state, next_state)

    execute_transition(context, evt, next_state)
  end

  def execute_transition(context = %EventContext{state: state}, %Evt{}, next_state) do
    next_state = change_state(state, next_state)
    %{context | state: next_state}
  end

  def change_state(current_state, :no_change), do: current_state
  def change_state(_, next_state), do: next_state

  def optional_store(%Evt{content: :no_evt_content}), do: []
  def optional_store(%Evt{content: tuple}) when is_tuple(tuple), do: [Action.store(tuple)]

  def lookup(decision_tree, key) do
    Map.get(decision_tree, key, @nop)
  end

  @doc """
   Check if there are  particular instructions for the current state, 
   Returns [ actions ]
  """
  def instructions(current_state, decision_tree, evt_name) do
    key = {current_state, evt_name}
    lookup(decision_tree, key)
  end

  @doc """
   Check if there are default instructions for this event_name that apply to any state.  
   Returns [ actions ]
  """
  def any_state_instructions(current_state, decision_tree, evt_name) do
    key = {:any, evt_name}
    do_nothing = {current_state, []}
    Map.get(decision_tree, key, do_nothing)
  end
end
