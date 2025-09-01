const redisClient = require("./redis");
// const Item = require("../models/item");

const shopRefresh = (itemCount: number) => {
  setInterval(async () => {
    // const items = await Item.find();
    const indexArr: number[] = [];
    let itemMap: Record<string, any> = {};
    for (let i = 0; i < itemCount; i++) {
      let newIndex = Math.floor(Math.random() * itemCount);
      console.log(newIndex);
      while (indexArr.includes(newIndex)) {
        newIndex = Math.floor(Math.random() * itemCount);
        console.log(newIndex);
      }
      indexArr.push(newIndex);
    }
    for (let i = 0; i < itemCount; i++) {
      // itemMap.i = items[indexArr[i]];
      // const key = i;
      itemMap[i] = "test" + [indexArr[i]];
    }
    //temp
    // itemMap = {
    //   1: "test",
    //   2: "test2",
    //   3: "test3",
    //   4: "test4",
    // };
    console.log(itemMap);
    await redisClient.set("flutter:shop", JSON.stringify(itemMap));
    //randomly generate number from 1-itemCount 5 times and use those items in a json
    //  and then put it into redis as map
    // }, 3600000);
  }, 3600000);
};

module.exports = shopRefresh;
