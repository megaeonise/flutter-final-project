import { NextFunction, Request, Response } from "express";

const errorHandler = (
  error: Error,
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  console.error(error.message);
  res.status(400).json({
    error: error.message.split("\n"),
  });
  next(error);
};
module.exports = errorHandler;
