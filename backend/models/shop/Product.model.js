import mongoose from "mongoose";

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },

    description: {
      type: String,
      trim: true
    },

    price: {
      type: Number,
      required: true,
      min: 0
    },

    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      default: null
    },

    images: [
      {
        type: String,
        trim: true
      }
    ],

    astrologyType: {
      type: String,
      enum: ["gemstone", "pooja", "report", "consultation"],
      default: "gemstone"   // ✅ prevents 500 error
    },

    stock: {
      type: Number,
      default: 0,
      min: 0
    },

    deliveryType: {
      type: String,
      enum: ["physical", "digital"],
      default: "physical"
    },

    isActive: {
      type: Boolean,
      default: true
    },

    isDeleted: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true
  }
);

export default mongoose.model("Product", productSchema);
