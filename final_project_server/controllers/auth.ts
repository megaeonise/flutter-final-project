// require("dotenv").config();
import { Request, Response } from "express";

const authRouter = require("express").Router();
// const auth = require("../middleware/auth");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const { JWT_SECRETKEY, JWT_SECRETKEY_2 } = require("../util/config");
// const { OAuth2Client } = require("google-auth-library");
// const client = new OAuth2Client();
const dns = require("dns/promises");
const nodemailer = require("nodemailer");
// const redisClient = require("../util/redis");

const emailCheck = (email: string) => {
  const re = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
  if (!re.test(email.toLowerCase())) {
    console.log("email checkk failed :(");
    return false;
  }
  return true;
};
const domainCheck = async (email: string) => {
  const domain = email.split("@")[1];
  let address: string[] = [];
  let errors: string[] = [];
  await dns
    .resolveMx(domain)
    .then((addresses: string) => address.push(addresses));
  return { address, errors };
};
const passwordCheck = (password: string) => {
  //   const re =
  //     /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/;
  //   console.log(typeof password);
  //   console.log(password);
  //   if (!re.test(String(password))) {
  //     console.log("password check failed :(");
  //     return false;
  //   }
  console.log(password);

  return true;
};

const sendVerificationMail = async (email: string, link: string) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "rikthmeowhumayun@gmail.com",
      pass: process.env.EMAIL_PASSWORD,
    },
  });
  (async () => {
    await transporter.sendMail({
      from: "rikthmeowhumayun@gmail.com",
      to: email,
      subject: "Verify your account",
      html: `<b>Dear user,</b> <br> <p>Please verify your account with the link below.</p> <br> <a href="${link}">Click to verify</a>`, // HTML body
    });
    // console.log("Message sent", info);
    console.log("Message sent");
  })();
};

// const getUser = async (req: Request, res: Response) => {
//   const user = await User.findById(req.user!.id)
//     .select("-password -verificationToken -createdAt -updatedAt -id")
//     .populate("friends tasks");
//   if (!user) throw Error("User does not exist");
//   res.status(200).json(user);
// };

const register = async (req: Request, res: Response) => {
  console.log(req.body);
  const { email, username, password } = req.body;
  const emailValidity = emailCheck(email);
  const domainValidity = domainCheck(email);
  const passwordValidity = passwordCheck(password);
  let errors: String[] = [];
  if (!emailValidity) errors.push("Email is invalid.");
  if (
    (await domainValidity).errors.length !== 0 &&
    (await domainValidity).address.length == 0
  ) {
    errors.push("Email domain is invalid or down.");
  }
  if (!email || !username || !password) {
    errors.push("Please fill in all the fields.");
  }
  if (password.length < 6 || !passwordValidity) {
    errors.push(
      "Password must be at least 6 characters and have one uppercase, one lowercase, one number and one special character"
    );
  }
  if (errors.length > 0) {
    res.status(400).json({ errors: errors });
  } else {
    const emailLowerCase = email.toLowerCase();
    const usernameLowerCase = username.toLowerCase();
    const userWithSameUsername = await User.findOne({
      username: usernameLowerCase,
    });
    const userWithSameEmail = await User.findOne({
      email: emailLowerCase,
    });
    if (userWithSameEmail) throw Error("Email is already taken.");
    if (userWithSameUsername) throw Error("Username is already taken.");
    const salt = await bcrypt.genSalt(10);
    if (!salt)
      throw Error("Something went wrong with encrypting the password.");
    const hash = await bcrypt.hash(password, salt);
    if (!hash) throw Error("Something went wrong hashing the password.");
    const verificationToken = jwt.sign(
      { username: username, email: emailLowerCase },
      JWT_SECRETKEY_2,
      {
        expiresIn: 28800,
      }
    );
    const newUser = new User({
      email: emailLowerCase,
      username: usernameLowerCase,
      password: hash,
      verificationToken: verificationToken,
    });
    const savedUser = await newUser.save();
    if (!savedUser) throw Error("Failed to register the user.");
    const userForToken = {
      username: savedUser.username,
      id: savedUser.id,
    };
    const token = jwt.sign(userForToken, JWT_SECRETKEY, {
      expiresIn: 28800,
    });
    sendVerificationMail(
      savedUser.email,
      `https://flutter-final-project-server.fly.dev/auth/verify/${verificationToken}`
    ); //change based on production or dev
    req.session!.token = token;
    res.status(200).json({
      msg: "Please check your email and verify your account",
    });
  }
};

const login = async (req: Request, res: Response) => {
  const { username, password } = req.body;
  const usernameLowerCase = username.toLowerCase();
  const user = await User.findOne({ username: usernameLowerCase });
  if (!user) throw Error("No user under this username exists.");
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) throw Error("Invalid credientials.");
  const userForToken = {
    username: user.username,
    id: user.id,
  };
  const token = jwt.sign(userForToken, JWT_SECRETKEY, {
    expiresIn: 28800,
  });
  req.session!.token = token;
  if (!user.verified) {
    sendVerificationMail(
      user.email,
      `https://flutter-final-project-server.fly.dev/auth/verify/${user.verificationToken}`
    ); //change based on production or dev
    res.status(200).json({
      msg: "Please check your email and verify your account",
    });
  } else {
    res.status(200).send();
  }
};

const verify = async (req: Request, res: Response) => {
  const user = await User.findOne({ verificationToken: req.params.token });
  user.verified = true;
  await user.save();
  res.status(200).json({ msg: `${user.username} has been verified.` });
};
const logout = (req: Request, res: Response) => {
  if (req.session) {
    req.session.destroy();
  }
  res.status(200).json({ msg: "User logged out." });
};

// authRouter.get("/user", auth, getUser);
authRouter.post("/logout", logout);
authRouter.post("/register", register);
authRouter.post("/login", login);
authRouter.get("/verify/:token", verify);

// authRouter.post("/google_login", google_login);
// refactor to reuse error check code and stuff

// // verify a user

module.exports = authRouter;
