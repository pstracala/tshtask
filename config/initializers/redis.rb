uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
REDIS_URL = Redis.new(:url => uri)