defmodule ChurchifyWeb.AuthEmail do
  use Bamboo.Phoenix, view: ChurchifyWeb.AuthEmailView

  import Bamboo.Email

  import ChurchifyWeb.Gettext

  def session_link(token) do
    new_email()
    |> to(token.user.email)
    |> from("info@churchify.com")
    |> subject(gettext("Your login link"))
    |> render(:session_link, token: token.value)
  end
end
