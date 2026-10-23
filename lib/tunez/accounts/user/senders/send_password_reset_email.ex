defmodule Tunez.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender
  use TunezWeb, :verified_routes

  alias Tunez.Mailer

  @impl true
  def send(user, token, _) do
    Mailer.deliver(user.email, "Reset your password", body(token: token))
  end

  defp body(params) do
    url = url(~p"/password-reset/#{params[:token]}")

    """
    <p>Click this link to reset your password:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
