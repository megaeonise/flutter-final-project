const redisClient = require("./redis");
const Item = require("../models/item");

const shopRefresh = (itemCount: number) => {
  setInterval(() => {
    // const items = await Item.find();

    //randomly generate number from 1-itemCount 5 times and use those items in a json
    //  and then put it into redis as map
    // }, 3600000);
    refreshFunction(itemCount);
  }, 3600000);
};
const refreshFunction = async (itemCount: number) => {
  const items = await Item.find();
  const indexArr: number[] = [];
  let itemMap: String[] = [];
  for (let i = 0; i < items.length; i++) {
    let newIndex = Math.floor(Math.random() * items.length);
    console.log(newIndex);
    while (indexArr.includes(newIndex)) {
      newIndex = Math.floor(Math.random() * items.length);
      console.log(newIndex);
    }
    indexArr.push(newIndex);
  }
  for (let i = 0; i < itemCount; i++) {
    // itemMap.i = items[indexArr[i]];
    // const key = i;
    console.log(items[indexArr[i]]);
    itemMap.push(items[indexArr[i]].id);
  }
  //temp
  // itemMap = {
  //   1: "test",
  //   2: "test2",
  //   3: "test3",
  //   4: "test4",
  // };
  console.log(itemMap);
  await redisClient.set("flutter:shop", itemMap.toString());
};

module.exports = { shopRefresh, refreshFunction };
