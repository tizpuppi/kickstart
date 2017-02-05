defmodule Kickstart.Email do
  import Bamboo.Email

  def registration_email(recepient) do
    base_email()
    |> to(recepient)
    |> subject("Registration!")
    |> text_body("Confirm your email address.")
  end

  def registration_email(recepient, token) do
    base_email()
    |> to(recepient)
    |> subject("Registration!")
    |> text_body("Click here to confirm your email address: #{token_url(token)}")
  end

  defp token_url(token) do
    Kickstart.Router.Helpers.auth_url(Kickstart.Endpoint, :confirm_token, token)
  end

  defp base_email do
    new_email()
    |> from("noreply@kickstart")
    |> put_header("Reply-To", "support@kickstart")
  end
end
