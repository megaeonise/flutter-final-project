import express from "express";
const mongoose = require("mongoose");
const cors = require("cors");
const redisClient = require("./util/redis");
const { RedisStore } = require("connect-redis");
const { shopRefresh } = require("./util/shop");
const { PORT, MONGODB_URL, REDIS_SECRET } = require("./util/config");
const errorHandler = require("./middleware/errorHandler");
const session = require("express-session");
const authRouter = require("./controllers/auth");
const friendRouter = require("./controllers/friend");
const taskRouter = require("./controllers/task");
const shopRouter = require("./controllers/shop");

const app = express();
app.use(cors());
app.use(errorHandler);

redisClient.connect().catch((err: Error) => console.log(err));
const redisStore = new RedisStore({
  client: redisClient,
  prefix: "flutter:",
});
app.set("trust proxy", 1);
app.use(
  session({
    store: redisStore,
    resave: false,
    saveUninitialized: false,
    secret: REDIS_SECRET,
    cookie: {
      maxAge: 28800000,
      httpOnly: process.env.NODE_ENV === "development",
      // httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      // secure: false,
      sameSite: "lax",
    },
  })
);
app.use(express.json());

app.use("/auth", authRouter);
app.use("/friend", friendRouter);
app.use("/task", taskRouter);
app.use("/shop", shopRouter);

console.log({
  httpOnly: process.env.NODE_ENV === "development",
  secure: process.env.NODE_ENV === "production",
});
const start = () => {
  app.listen(PORT, () => {
    mongoose.connect(MONGODB_URL);
    console.log(`Server started in port ${PORT}`);
  });
  console.log("its over");
  // shopRefresh(5); //shopRefresh(itemCount)
};

// const Item = require("./models/item");

// const shopRefresh = (itemCount: number) => {
//   setInterval(async () => {
//     const items = await Item.find();
//     const indexArr: number[] = [];
//     let itemMap: Record<string, any> = {};
//     for (let i = 0; i < itemCount; i++) {
//       let newIndex = Math.floor(Math.random() * itemCount);
//       console.log(newIndex);
//       while (indexArr.includes(newIndex)) {
//         newIndex = Math.floor(Math.random() * itemCount);
//         console.log(newIndex);
//       }
//       indexArr.push(newIndex);
//     }
//     for (let i = 0; i < itemCount; i++) {
//       itemMap.i = items[indexArr[i]];
//     }
//     //temp
//     itemMap = {
//       1: "test",
//       2: "test2",
//       3: "test3",
//       4: "test4",
//     };
//     console.log(itemMap);
//     await redisClient.set("flutter:shop", JSON.stringify(itemMap));
//     //randomly generate number from 1-itemCount 5 times and use those items in a json
//     //  and then put it into redis as map
//     // }, 3600000);
//   }, 3600);
// };
shopRefresh(5);
start();
