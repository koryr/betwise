defmodule Betwise.BetTypesTest do
  use Betwise.DataCase

  alias Betwise.BetTypes

  describe "bet_types" do
    alias Betwise.BetTypes.BetType

    import Betwise.BetTypesFixtures

    @invalid_attrs %{bet_type_name: nil}

    test "list_bet_types/0 returns all bet_types" do
      bet_type = bet_type_fixture()
      assert BetTypes.list_bet_types() == [bet_type]
    end

    test "get_bet_type!/1 returns the bet_type with given id" do
      bet_type = bet_type_fixture()
      assert BetTypes.get_bet_type!(bet_type.id) == bet_type
    end

    test "create_bet_type/1 with valid data creates a bet_type" do
      valid_attrs = %{bet_type_name: "some bet_type_name"}

      assert {:ok, %BetType{} = bet_type} = BetTypes.create_bet_type(valid_attrs)
      assert bet_type.bet_type_name == "some bet_type_name"
    end

    test "create_bet_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BetTypes.create_bet_type(@invalid_attrs)
    end

    test "update_bet_type/2 with valid data updates the bet_type" do
      bet_type = bet_type_fixture()
      update_attrs = %{bet_type_name: "some updated bet_type_name"}

      assert {:ok, %BetType{} = bet_type} = BetTypes.update_bet_type(bet_type, update_attrs)
      assert bet_type.bet_type_name == "some updated bet_type_name"
    end

    test "update_bet_type/2 with invalid data returns error changeset" do
      bet_type = bet_type_fixture()
      assert {:error, %Ecto.Changeset{}} = BetTypes.update_bet_type(bet_type, @invalid_attrs)
      assert bet_type == BetTypes.get_bet_type!(bet_type.id)
    end

    test "delete_bet_type/1 deletes the bet_type" do
      bet_type = bet_type_fixture()
      assert {:ok, %BetType{}} = BetTypes.delete_bet_type(bet_type)
      assert_raise Ecto.NoResultsError, fn -> BetTypes.get_bet_type!(bet_type.id) end
    end

    test "change_bet_type/1 returns a bet_type changeset" do
      bet_type = bet_type_fixture()
      assert %Ecto.Changeset{} = BetTypes.change_bet_type(bet_type)
    end
  end
end
