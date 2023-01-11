defmodule LvEx.Repo do
  use Ecto.Repo,
    otp_app: :lv_ex,
    adapter: Ecto.Adapters.Postgres
end
