import express from "express";

declare global {
  namespace Express {
    interface Request {
      session?: Record<string, any>;
      user?: Record<string, any>;
    }
  }
}
