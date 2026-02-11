# Redis info

redis_version = nil

DEFAULT_REDIS_VERSION = "7.4"

begin
  if gemspecs.key?("redis")
    maybe_redis_version = ask "Which Redis version do you want to use?", default: DEFAULT_REDIS_VERSION

    redis_version = maybe_redis_version.empty? ? DEFAULT_REDIS_VERSION : maybe_redis_version

    say_status :info, "Redis: #{redis_version}"
  end
end
