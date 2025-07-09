import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# database: "wazuh_test#{System.get_env("MIX_TEST_PARTITION")}",
config :wazuh, Wazuh.Repo,
  username: "webuser",
  password: "webpassword",
  hostname: "localhost",
  database: "cve_db",
  port: 6432,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wazuh, WazuhWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RdrT26BLj77s2oPYwy2y9+7rb1FBLkBDSEt8cLgr3R+BE6WaxoAX0FLsSiH4YL3I",
  server: false

# In test we don't send emails
config :wazuh, Wazuh.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
