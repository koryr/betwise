defmodule Betwise.Model.MyBet do
  defstruct game_id: nil, selection_id: nil, odds: 0, game_name: nil, selection_name: nil
end

defmodule Betwise.Model.Mail do
  @derive {Swoosh.Email.Recipient, name: :name, address: :email}
  defstruct [:email_id, :name, :email, :subject, :other_props]
end
