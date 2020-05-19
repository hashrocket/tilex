use Mix.Config

config :tilex, :organization_name, System.get_env("ORGANIZATION_NAME")
config :tilex, :canonical_domain, System.get_env("CANONICAL_DOMAIN")
config :tilex, :default_twitter_handle, System.get_env("DEFAULT_TWITTER_HANDLE")
config :tilex, :cors_origin, System.get_env("CORS_ORIGIN")
config :tilex, :hosted_domain, System.get_env("HOSTED_DOMAIN")
config :tilex, :guest_author_whitelist, System.get_env("GUEST_AUTHOR_WHITELIST")
config :tilex, :date_display_tz, System.get_env("DATE_DISPLAY_TZ")
config :tilex, :imgur_client_id, System.get_env("IMGUR_CLIENT_ID")

config :tilex,
       :rate_limiter_requests_per_time_period,
       System.get_env("RATE_LIMIT_REQUESTS_PER_TIME_PERIOD") || 5

config :tilex,
       :rate_limiter_time_period_minutes,
       System.get_env("RATE_LIMIT_TIME_PERIOD_MINUTES") || 1

config :tilex,
       :rate_limiter_cleanup_interval,
       # every 10 hours
       System.get_env("RATE_LIMIT_CLEANUP_INTERVAL") || 10 * 60 * 60_000

config :extwitter, :oauth,
  consumer_key: System.get_env("twitter_consumer_key"),
  consumer_secret: System.get_env("twitter_consumer_secret"),
  access_token: System.get_env("twitter_access_token"),
  access_token_secret: System.get_env("twitter_access_token_secret")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
