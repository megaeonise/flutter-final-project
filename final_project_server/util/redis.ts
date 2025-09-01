const { createClient } = require("redis");
const { REDIS_URL, REDIS_PASSWORD, REDIS_PORT } = require("./config");
const redisClient = createClient({
  username: "default",
  password: REDIS_PASSWORD,
  socket: {
    host: REDIS_URL,
    port: REDIS_PORT,
  },
});

module.exports = redisClient;
