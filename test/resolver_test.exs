defmodule EventFsm.ResolverTest do
  use EventFsm.EventFsmCase
  alias EventFsm.Resolver
  alias EventFsm.Action

  describe "exec actions" do
    setup :using_dispatcher_reflector

    test "empty", %{rez: rez} do
      actions = []
      # When
      rez = Resolver.exec(rez, actions)
      # Then
      assert rez.data == %{}
    end

    test "store", %{rez: rez} do
      actions = [Action.store({:key_of_data, :value_of_data})]
      # When
      rez = Resolver.exec(rez, actions)
      # Then
      assert rez.data == %{key_of_data: :value_of_data}
    end
  end

  describe "using_dispatcher_reflector" do
    setup :using_dispatcher_reflector

    test "store", %{rez: rez} do
      actions = [Action.store({:coin, 5})]
      # When
      rez = Resolver.exec(rez, actions)
      # Then
      assert rez.data == %{coin: 5}
    end

    test "unlock", %{rez: rez} do
      actions = [Action.unlock()]
      # When
      _rez = Resolver.exec(rez, actions)
      # Then

      # TODO:      
      # expected_message = ""
      # assert_receive ^expected_message 
    end
  end

  defp using_dispatcher_reflector(_context) do
    rez =
      %Resolver{}
      |> Resolver.replace_dispatcher(DispatcherReflector)

    {:ok, rez: rez}
  end
end
