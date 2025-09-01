require("dotenv").config();

const PORT = process.env.PORT || 3000;
const MONGODB_URL = process.env.MONGO_URL;
const REDIS_URL = process.env.REDIS_URL;
const REDIS_PASSWORD = process.env.REDIS_PASSWORD;
const REDIS_PORT = process.env.REDIS_PORT;
const REDIS_SECRET = process.env.REDIS_SECRET;
const JWT_SECRETKEY = process.env.JWT_SECRETKEY;
const JWT_SECRETKEY_2 = process.env.JWT_SECRETKEY_2;
module.exports = {
  MONGODB_URL,
  PORT,
  REDIS_URL,
  REDIS_PASSWORD,
  REDIS_PORT,
  REDIS_SECRET,
  JWT_SECRETKEY,
  JWT_SECRETKEY_2,
};
