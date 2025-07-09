defmodule Wazuh.Repo do
  use Ecto.Repo,
    otp_app: :wazuh,
    adapter: Ecto.Adapters.Postgres
end
