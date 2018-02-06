use Mix.Config

config :your_url_ex, YourUrlEx.Endpoint,
  http: [port: 4000, compress: true],
  url: [scheme: "http", host: 'localhost', port: 80],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  code_reloader: false,
  cache_static_manifest: "priv/static/manifest.json",
  server: true

config :your_url_ex, YourUrlEx.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  pool_size: 20

config :exq,
  host: System.get_env("REDIS_HOST"),
  port: 6379

config :logger, level: :info
