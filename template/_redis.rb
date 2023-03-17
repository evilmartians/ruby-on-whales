# Redis info

redis_version = nil

DEFAULT_REDIS_VERSION = "6.0"

begin
  if gemspecs.key?("redis")
    maybe_redis_version = ask "Which Redis version do you want to use? (Press ENTER to use #{DEFAULT_REDIS_VERSION})"

    redis_version = maybe_redis_version.empty? ? DEFAULT_REDIS_VERSION : maybe_redis_version
  end
end
