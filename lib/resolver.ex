defmodule EventFsm.Resolver do
  @moduledoc """
  receives a list of Actions.
  1) store the value given by :store Actions
  2) execute other Action
  """

  alias EventFsm.Action
  alias EventFsm.Resolver
  alias EventFsm.Dispatcher

  defstruct data: %{}, config: %{dispatcher: Dispatcher}

  def new() do
    %Resolver{}
  end

  # --- Interface ---
  def exec_one_action(action, rez) do
    {action, exec(rez, action)}
  end

  def exec(rez = %Resolver{}, actions) when is_list(actions) do
    {_actions, rez} = Enum.map_reduce(actions, rez, &exec_one_action/2)
    rez
  end

  # --- Internal Routing --- 
  def exec(rez, %Action{name: :store, content: content}), do: store(rez, content)
  def exec(rez, %Action{}), do: rez

  # --- Implementations --- 

  def store(rez = %Resolver{}, {name, value}) do
    data = rez.data
    data = Map.put(data, name, value)
    %{rez | data: data}
  end

  defp dispatcher(%Resolver{config: %{dispatcher: dispatcher}}) do
    dispatcher
  end

  def replace_dispatcher(rez = %Resolver{}, dispatcher) do
    put_in(rez.config[:dispatcher], dispatcher)
  end
end
