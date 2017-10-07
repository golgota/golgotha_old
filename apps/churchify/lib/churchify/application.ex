defmodule Churchify.Application do
  @moduledoc """
  The Churchify Application Service.

  The churchify system business domain lives in this application.

  Exposes API to clients such as the `ChurchifyWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Churchify.Repo, []),
    ], strategy: :one_for_one, name: Churchify.Supervisor)
  end
end
