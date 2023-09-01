defmodule Betwise.EmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Emails` context.
  """

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        content: "some content",
        email_from: "some email_from",
        recipient: "some recipient",
        subject: "some subject"
      })
      |> Betwise.Emails.create_email()

    email
  end
end
