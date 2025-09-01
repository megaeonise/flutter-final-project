// require("dotenv").config();
import { NextFunction, Request, Response } from "express";
const redisClient = require("../util/redis");
const jwt = require("jsonwebtoken");

const JWT_SECRETKEY = process.env.JWT_SECRETKEY;

//@ts-ignore
module.exports = async (req: Request, res: Response, next: NextFunction) => {
  const cookie = await redisClient.get(`flutter:${req.session!.id}`);
  if (!cookie)
    return res
      .status(401)
      .json({ msg: "Session expired, please login again." });
  const token = JSON.parse(cookie).token;
  if (!req.session!.cookie.maxAge) {
    req.session!.destroy();
    return res.status(401).json({ msg: "Session expired" });
  }

  if (!token)
    return res
      .status(401)
      .json({ msg: "Session expired, please login again." });

  if (token) {
    const user = jwt.verify(token, JWT_SECRETKEY);
    req.user = user;
    next();
  } else {
    res.status(400).json({ msg: "Session is not valid" });
  }
};
