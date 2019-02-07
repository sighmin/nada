defmodule NadaWeb.SessionView do
  use NadaWeb, :view

  def email_lookup_heading(assigns) do
    if assigns[:email] do
      "We found you! Please confirm your email."
    else
      "We can't find you. Please enter your email."
    end
  end

  def email_lookup_cta(assigns) do
    if assigns[:email] do
      "Yup, that's mine"
    else
      "Submit"
    end
  end
end
