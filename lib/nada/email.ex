defmodule Nada.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: NadaWeb.EmailView
  @from "simon.vandyk@gmail.com"

  def confirm_email(user) do
    base_email(user.email)
    |> subject("Welcome to nada!")
    |> assign(:token, user.token)
    |> render("confirm_email.html")
  end

  def confirm_otp(user) do
    base_email(user.email)
    |> subject("Login to nada")
    |> assign(:otp, user.otp)
    |> render("confirm_otp.html")
  end

  defp base_email(email) do
    new_email()
    |> to(email)
    |> from(@from)
    |> put_html_layout({NadaWeb.LayoutView, "email.html"})
  end
end
