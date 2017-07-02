defmodule Churchify.Factory do
  use ExMachina.Ecto, repo: Churchify.Repo

  def user_factory do
    %Churchify.Auth.User{
      email: sequence(:email, &"kelvin.stinghen#{&1}@example.com"),
    }
  end

  def token_factory do
    user = insert(:user)
    %Churchify.Auth.Token{
      value: Churchify.Auth.Token.generate_token(user),
      user: user,
    }
  end
end
