defmodule Nada.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: NadaWeb.EmailView
  @from "simon.vandyk@gmail.com"

  def confirm_email(user) do
    base_email(user.email)
    |> subject("Welcome to nada!")
    |> render("confirm_email.html")
  end

  defp base_email(email) do
    new_email()
    |> to(email)
    |> from(@from)
    |> put_html_layout({NadaWeb.LayoutView, "email.html"})
  end
end
