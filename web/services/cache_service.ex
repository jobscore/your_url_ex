defmodule YourUrlEx.CacheService do
  alias Redix

  def get(key) do
    {:ok, result } = Redix.command(connection(), ["GET", key])

    result
  end

  def set(key, value) do
    {:ok, result } = Redix.command(connection(), ["SET", key, value])

    result
  end

  def connection do
    { :ok, conn } = Redix.start_link(host: System.get_env("REDIS_HOST"), port: 6379)

    conn
  end
end
