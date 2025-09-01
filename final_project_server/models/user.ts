import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
    },
    password: {
      type: String,
    },
    verified: {
      type: Boolean,
      default: false,
    },
    verificationToken: {
      type: String,
    },
    coin: {
      type: Number,
      default: 0,
    },
    points: {
      type: Number,
      default: 0,
    },
    friends: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    inventory: [{ type: mongoose.Schema.Types.ObjectId, ref: "Item" }],
    tasks: [{ type: mongoose.Schema.Types.ObjectId, ref: "Task" }],
  },
  { timestamps: true }
);
userSchema.set("toJSON", {
  transform: (_document, returnedObject) => {
    console.log(returnedObject);
    //@ts-ignore
    returnedObject.id = returnedObject._id.toString();
    //@ts-ignore
    delete returnedObject._id;
    //@ts-ignore
    delete returnedObject.__v;
    delete returnedObject.password;
  },
});

module.exports = mongoose.model("User", userSchema);
