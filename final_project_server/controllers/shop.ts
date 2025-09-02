// require("dotenv").config();
import { Request, Response } from "express";

const shopRouter = require("express").Router();
const auth = require("../middleware/auth");
const User = require("../models/user");
const Item = require("../models/item");
const redisClient = require("../util/redis");
const { refreshFunction } = require("../util/shop");

const getShop = async (_req: Request, res: Response) => {
  const shopIdString = await redisClient.get("flutter:shop");
  const shopIdArray = shopIdString.split(",");
  const shop = await Item.find().where("_id").in(shopIdArray);
  res.status(200).json(shop);
};

const getInventory = async (req: Request, res: Response) => {
  const user = await User.findById(req.user!.id)
    .select(
      "-password -verificationToken -createdAt -updatedAt -verified -friends -id"
    )
    .populate("inventory");
  res.status(200).json(user.inventory);
};

const addItem = async (req: Request, res: Response) => {
  const { name, description, rarity, cost, sprite } = req.body;
  const newItem = new Item({
    name: name,
    description: description,
    rarity: rarity,
    cost: cost,
    sprite: sprite,
  });
  const savedItem = await newItem.save();
  res.status(200).send(savedItem);
};

const buyItem = async (req: Request, res: Response) => {
  const { itemId } = req.body;
  const user = await User.findById(req.user!.id).select(
    "-password -verificationToken -createdAt -updatedAt -verified -friends -id"
  );
  const item = await Item.findById(itemId);
  if (!user.inventory.includes(itemId) && user.coin >= item.cost) {
    user.coin -= item.cost;
    user.inventory = [...user.inventory, itemId];
    await user.save();
    res.status(200).json(item);
  } else {
    throw Error("You already have this item!");
  }
};

const gachaItem = async (req: Request, res: Response) => {
  const { gachaCost } = req.body;
  const user = await User.findById(req.user!.id).select(
    "-password -verificationToken -createdAt -updatedAt -verified -friends -id"
  );
  const items = await Item.find();
  const gachaReward = items[Math.floor(Math.random() * items.length)];
  if (!user.inventory.includes(gachaReward.id) && user.coin >= gachaCost) {
    user.coin -= gachaCost;
    user.inventory = [...user.inventory, gachaReward.id];
    await user.save();
    res.status(200).json(gachaReward);
  } else {
    throw Error("You already have this item!");
  }
};

const forceRefresh = async (_req: Request, res: Response) => {
  refreshFunction(5);
  res.status(200).send("Shop rerolled");
};

// const addToInventory = async (itemId: String) => {

// }

shopRouter.get("/shopReroll", auth, forceRefresh);
shopRouter.post("/add", auth, addItem);
shopRouter.get("/get", auth, getShop);
shopRouter.put("/buy", auth, buyItem);
shopRouter.put("/roll", auth, gachaItem);
shopRouter.get("/inventory", auth, getInventory);

module.exports = shopRouter;
