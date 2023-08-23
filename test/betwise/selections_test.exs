defmodule Betwise.SelectionsTest do
  use Betwise.DataCase

  alias Betwise.Selections

  describe "selections" do
    alias Betwise.Selections.Selection

    import Betwise.SelectionsFixtures

    @invalid_attrs %{name: nil}

    test "list_selections/0 returns all selections" do
      selection = selection_fixture()
      assert Selections.list_selections() == [selection]
    end

    test "get_selection!/1 returns the selection with given id" do
      selection = selection_fixture()
      assert Selections.get_selection!(selection.id) == selection
    end

    test "create_selection/1 with valid data creates a selection" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Selection{} = selection} = Selections.create_selection(valid_attrs)
      assert selection.name == "some name"
    end

    test "create_selection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Selections.create_selection(@invalid_attrs)
    end

    test "update_selection/2 with valid data updates the selection" do
      selection = selection_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Selection{} = selection} = Selections.update_selection(selection, update_attrs)
      assert selection.name == "some updated name"
    end

    test "update_selection/2 with invalid data returns error changeset" do
      selection = selection_fixture()
      assert {:error, %Ecto.Changeset{}} = Selections.update_selection(selection, @invalid_attrs)
      assert selection == Selections.get_selection!(selection.id)
    end

    test "delete_selection/1 deletes the selection" do
      selection = selection_fixture()
      assert {:ok, %Selection{}} = Selections.delete_selection(selection)
      assert_raise Ecto.NoResultsError, fn -> Selections.get_selection!(selection.id) end
    end

    test "change_selection/1 returns a selection changeset" do
      selection = selection_fixture()
      assert %Ecto.Changeset{} = Selections.change_selection(selection)
    end
  end
end
