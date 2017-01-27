defmodule Kickstart.EmailTest do
  use ExUnit.Case
  use Bamboo.Test

  test "welcome email" do
    user = %Kickstart.User{username: "bobo", email: "bobo@example.com"}

    email = Kickstart.Email.registration_email(user.email)

    assert email.to == user.email
    assert email.subject == "Registration!"
    assert email.text_body =~ "Confirm your email address."

  end
end
