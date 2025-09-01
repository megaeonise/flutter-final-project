import mongoose from "mongoose";

const taskSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      trim: true,
      required: true,
    },
    body: {
      type: String,
      trim: true,
      required: true,
    },
    urgent: {
      type: Boolean,
      default: false,
    },
    color: {
      type: String,
      default: "FFFFFF",
    },
    completionTime: {
      type: Number,
      default: 1,
    },
    user: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  },
  { timestamps: true }
);
taskSchema.set("toJSON", {
  transform: (_document, returnedObject) => {
    //@ts-ignore
    returnedObject.id = returnedObject._id.toString();
    //@ts-ignore
    delete returnedObject._id;
    //@ts-ignore
    delete returnedObject.__v;
  },
});

module.exports = mongoose.model("Task", taskSchema);
