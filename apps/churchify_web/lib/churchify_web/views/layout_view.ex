defmodule Churchify.Web.LayoutView do
  use Churchify.Web, :view

  alias Churchify.Auth.User

  @gravatar_size 48

  def gravatar_url(user, size \\ @gravatar_size),
    do: "https://gravatar.com/avatar/#{gravatar_id(user)}.png?s=#{size}&d=mm"

  defp gravatar_id(nil), do: "no_user"
  defp gravatar_id(%User{email: email}),
    do: Base.encode16(:erlang.md5(email), case: :lower)
end
