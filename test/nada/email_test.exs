defmodule Nada.EmailTest do
  use ExUnit.Case
  use Bamboo.Test
  alias Nada.{Mailer,User,Email}

  test "confirm_email has the registration token" do
    bob = User.new(%{"email" => "bob@example.com"})
    email = Email.confirm_email(bob)

    assert email.to == bob.email
    assert email.from == "simon.vandyk@gmail.com"
    assert email.subject == "Welcome to nada!"
    assert email.html_body =~ ~r/Confirm/
    assert email.html_body =~ ~r/#{bob.token}/
  end

  test "confirm_otp has the login token" do
    bob = User.new(%{"email" => "bob@example.com"})
    bob = User.generate_otp(bob)
    email = Email.confirm_otp(bob)

    assert email.to == bob.email
    assert email.from == "simon.vandyk@gmail.com"
    assert email.subject == "Login to nada"
    assert email.html_body =~ ~r/Login/
    assert email.html_body =~ ~r/#{bob.otp}/
  end

  test "sending an email" do
    bob = User.new(%{"email" => "bob@example.com"})
    email = Email.confirm_email(bob)
    email |> Mailer.deliver_now
    assert_delivered_email email
  end
end
