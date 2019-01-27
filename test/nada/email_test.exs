defmodule Nada.EmailTest do
  use ExUnit.Case
  use Bamboo.Test
  alias Nada.{Mailer,User,Email}

  test "creating an email" do
    bob = %User{email: "bob@example.com"}
    email = Email.confirm_email(bob)

    assert email.to == bob.email
    assert email.from == "simon.vandyk@gmail.com"
    assert email.subject == "Welcome to nada!"
    assert email.html_body =~ ~r/Confirm/
  end

  test "sending an email" do
    bob = %User{email: "bob@example.com"}
    email = Email.confirm_email(bob)
    email |> Mailer.deliver_now
    assert_delivered_email email
  end
end
