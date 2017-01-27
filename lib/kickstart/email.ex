defmodule Kickstart.Email do
  import Bamboo.Email

  def registration_email(recepient) do
    base_email()
    |> to(recepient)
    |> subject("Registration!")
    |> text_body("Confirm your email address.")
  end

  defp base_email do
    new_email()
    |> from("noreply@kickstart")
    |> put_header("Reply-To", "support@kickstart")
  end
end
