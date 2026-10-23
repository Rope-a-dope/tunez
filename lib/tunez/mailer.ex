defmodule Tunez.Mailer do
  use Swoosh.Mailer, otp_app: :tunez

  import Swoosh.Email

  @doc "Builds and delivers a plain HTML email from the app's noreply address."
  def deliver(to, subject_line, html) do
    new()
    # TODO: Replace with your email
    |> from({"noreply", "noreply@example.com"})
    |> to(to_string(to))
    |> subject(subject_line)
    |> html_body(html)
    |> deliver!()
  end
end
