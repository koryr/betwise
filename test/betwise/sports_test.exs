defmodule Betwise.SportsTest do
  use Betwise.DataCase

  alias Betwise.Sports

  describe "sport_type" do
    alias Betwise.Sports.SportType

    import Betwise.SportsFixtures

    @invalid_attrs %{sport_name: nil}

    test "list_sport_type/0 returns all sport_type" do
      sport_type = sport_type_fixture()
      assert Sports.list_sport_type() == [sport_type]
    end

    test "get_sport_type!/1 returns the sport_type with given id" do
      sport_type = sport_type_fixture()
      assert Sports.get_sport_type!(sport_type.id) == sport_type
    end

    test "create_sport_type/1 with valid data creates a sport_type" do
      valid_attrs = %{sport_name: "some sport_name"}

      assert {:ok, %SportType{} = sport_type} = Sports.create_sport_type(valid_attrs)
      assert sport_type.sport_name == "some sport_name"
    end

    test "create_sport_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sports.create_sport_type(@invalid_attrs)
    end

    test "update_sport_type/2 with valid data updates the sport_type" do
      sport_type = sport_type_fixture()
      update_attrs = %{sport_name: "some updated sport_name"}

      assert {:ok, %SportType{} = sport_type} = Sports.update_sport_type(sport_type, update_attrs)
      assert sport_type.sport_name == "some updated sport_name"
    end

    test "update_sport_type/2 with invalid data returns error changeset" do
      sport_type = sport_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Sports.update_sport_type(sport_type, @invalid_attrs)
      assert sport_type == Sports.get_sport_type!(sport_type.id)
    end

    test "delete_sport_type/1 deletes the sport_type" do
      sport_type = sport_type_fixture()
      assert {:ok, %SportType{}} = Sports.delete_sport_type(sport_type)
      assert_raise Ecto.NoResultsError, fn -> Sports.get_sport_type!(sport_type.id) end
    end

    test "change_sport_type/1 returns a sport_type changeset" do
      sport_type = sport_type_fixture()
      assert %Ecto.Changeset{} = Sports.change_sport_type(sport_type)
    end
  end
end
