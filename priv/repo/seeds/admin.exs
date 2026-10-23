user =
  Tunez.Accounts.register_user!(
    "admin@example.com",
    "password123",
    "password123",
    authorize?: false
  )

Tunez.Accounts.set_user_role!(
  user,
  :admin,
  authorize?: false
)
