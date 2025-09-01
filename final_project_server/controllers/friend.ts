// require("dotenv").config();
import { Request, Response } from "express";

const friendRouter = require("express").Router();
const auth = require("../middleware/auth");
const User = require("../models/user");

const getUsers = async (_req: Request, res: Response) => {
  const users = await User.find().select(
    "-password -verificationToken -createdAt -updatedAt -inventory -verified -tasks -friends"
  );
  res.status(200).json(users);
};

const getFriends = async (req: Request, res: Response) => {
  const user = await User.findById(req.user!.id)
    .select(
      "-verificationToken -createdAt -updatedAt -inventory -verified -tasks -friends"
    )
    .populate({
      path: "friends",
      select:
        "-password -verificationToken -createdAt -updatedAt -inventory -verified -tasks -friends",
    });
  res.status(200).json(user.friends);
};

const addFriend = async (req: Request, res: Response) => {
  const { friendId } = req.body;
  const user = await User.findById(req.user!.id).select(
    "-verificationToken -createdAt -updatedAt -id"
  );
  console.log(user.friends);
  console.log(user.friends.includes(friendId));
  if (!user.friends.includes(friendId)) {
    user.friends = [...user.friends, friendId];
    await user.save();
    res.status(200).send("Friend added");
  } else {
    throw Error("You have already added this user");
  }
};

friendRouter.get("/users", auth, getUsers);
friendRouter.get("/friends", auth, getFriends);
friendRouter.post("/add", auth, addFriend);

module.exports = friendRouter;
