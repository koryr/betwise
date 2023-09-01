defmodule Betwise.EmailsTest do
  use Betwise.DataCase

  alias Betwise.Emails

  describe "emails" do
    alias Betwise.Emails.Email

    import Betwise.EmailsFixtures

    @invalid_attrs %{content: nil, email_from: nil, recipient: nil, subject: nil}

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Emails.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Emails.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      valid_attrs = %{content: "some content", email_from: "some email_from", recipient: "some recipient", subject: "some subject"}

      assert {:ok, %Email{} = email} = Emails.create_email(valid_attrs)
      assert email.content == "some content"
      assert email.email_from == "some email_from"
      assert email.recipient == "some recipient"
      assert email.subject == "some subject"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Emails.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      update_attrs = %{content: "some updated content", email_from: "some updated email_from", recipient: "some updated recipient", subject: "some updated subject"}

      assert {:ok, %Email{} = email} = Emails.update_email(email, update_attrs)
      assert email.content == "some updated content"
      assert email.email_from == "some updated email_from"
      assert email.recipient == "some updated recipient"
      assert email.subject == "some updated subject"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Emails.update_email(email, @invalid_attrs)
      assert email == Emails.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Emails.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Emails.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Emails.change_email(email)
    end
  end
end
