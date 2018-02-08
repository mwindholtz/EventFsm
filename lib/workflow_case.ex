defmodule EventFsm.WorkflowCase do
  @moduledoc """
  Test setup for workflow Rules
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias EventFsm.Evt
      alias EventFsm.Engine
      alias EventFsm.Transducer
      alias EventFsm.EventContext
      alias EventFsm.Action, as: ShouldThen
      alias EventFsm.SequenceGenerator
      alias EventFsm.Rules, as: Rules

      # Common Events

      def coin_deposited, do: Evt.coin_acceptor(:coin_deposited, {:coin, 5})
      def turned_once, do: Evt.turnstyle(:turned_once)

      def server do
        Engine.new(Rules.transition_rules())
      end

      def assert_workflow(workflow, limit \\ 1000) do
        steps = workflow |> Enum.take(limit)
        event_context = steps |> run_workflow(server())
        actual_names = action_names(event_context) |> Enum.reject(&action_name_is_store/1)
        expected_names = extract_actions(steps)

        assert actual_names == expected_names,
               "expected:#{inspect(expected_names)}\nactual:  #{inspect(actual_names)}"
      end

      def action_name_is_store(name) do
        name == :store
      end

      def extract_actions(workflow) do
        Enum.flat_map(workflow, fn tuple ->
          actions = elem(tuple, 1) |> List.flatten()
          Enum.map(actions, &name_of_action/1)
        end)
      end

      def action_names(event_context) do
        Enum.map(event_context.actions, &name_of_action/1)
      end

      def name_of_action(action = %ShouldThen{}) do
        action.name
      end

      def name_of_action(unexpected) do
        IO.inspect("Should be EventFsm.Action")
        raise inspect(unexpected)
      end

      # Run Workflows 
      def run_workflow(workflow, engine = %Engine{}) when is_list(workflow) do
        context = EventContext.new(engine)
        _run_workflow(workflow, context)
      end

      def _run_workflow([], context = %EventContext{}) do
        context
      end

      def _run_workflow([step | workflow], context = %EventContext{}) do
        {event, _ignore_expected_actions} = step
        context = Transducer.event(context, event)
        _run_workflow(workflow, context)
      end

      def gen_steps(workflow, image_name) do
        SequenceGenerator.stream_gen(workflow(), image_name) ++ [""]
      end

      def fixture_steps(image_name) do
        filepath = "test/fixtures/workflows/#{image_name}.txt"

        content =
          case File.read(filepath) do
            {:ok, content} -> content
            {:error, :enoent} -> raise "File not found #{filepath}"
          end

        String.split(content, "\n")
      end

      def assert_steps_match_fixture(workflow, image_name) do
        actual_steps = gen_steps(workflow, image_name)
        expected_steps = fixture_steps(image_name)
        assert actual_steps == expected_steps
      end
    end
  end

  setup _tags do
    :ok
  end
end
