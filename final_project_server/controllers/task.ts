// require("dotenv").config();
import { Request, Response } from "express";

const taskRouter = require("express").Router();
const auth = require("../middleware/auth");
const User = require("../models/user");
const Task = require("../models/task");

const getTasks = async (req: Request, res: Response) => {
  const user = await User.findById(req.user!.id)
    .select(
      "-password -verificationToken -createdAt -updatedAt -inventory -verified -tasks -friends -id"
    )
    .populate({
      path: "tasks",
      select: "-createdAt -updatedAt -user -startTime -endTime",
    });
  res.status(200).json(user.tasks);
};

const addTask = async (req: Request, res: Response) => {
  const { title, body, urgent, color, completionTime } = req.body; //add urgent, color and start end time later
  const user = await User.findById(req.user!.id).select(
    "-password -verificationToken -createdAt -updatedAt -inventory -verified -tasks -friends -id"
  );
  const newTask = new Task({
    title: title,
    body: body,
    urgent: urgent,
    color: color,
    completionTime: completionTime,
  });
  const savedTask = await newTask.save();
  user.tasks = [...user.tasks, savedTask.id];
  await user.save();
  res.status(200).send("Task added");
};

taskRouter.get("/tasks", auth, getTasks);
taskRouter.post("/add", auth, addTask);
module.exports = taskRouter;
