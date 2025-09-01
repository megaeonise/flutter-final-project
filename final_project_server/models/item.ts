import mongoose from "mongoose";

const itemSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
    required: true,
  },
  description: {
    type: String,
    trim: true,
    required: true,
  },
  rarity: {
    type: String,
    required: true,
  },
  cost: {
    type: Number,
    required: true,
  },
  sprite: {
    type: String,
    required: true,
  },
});
itemSchema.set("toJSON", {
  transform: (_document, returnedObject) => {
    //@ts-ignore
    returnedObject.id = returnedObject._id.toString();
    //@ts-ignore
    delete returnedObject._id;
    //@ts-ignore
    delete returnedObject.__v;
  },
});

module.exports = mongoose.model("Item", itemSchema);
