import Feedback from "../models/shop/feedback.model.js";
import Product from "../models/shop/Product.model.js";
import mongoose from "mongoose";


/* -------------------------------------------------------
   Helper: Recalculate and update product rating summary
--------------------------------------------------------*/
const updateProductRating = async (productId) => {
  const stats = await Feedback.aggregate([
    { $match: { productId: new mongoose.Types.ObjectId(productId) } },
    {
      $group: {
        _id: "$productId",
        avgRating: { $avg: "$rating" },
        reviewCount: { $sum: 1 },
      },
    },
  ]);

  if (stats.length > 0) {
    await Product.findByIdAndUpdate(productId, {
      averageRating: Number(stats[0].avgRating.toFixed(1)),
      numReviews: stats[0].reviewCount,
    });
  } else {
    await Product.findByIdAndUpdate(productId, {
      averageRating: 0,
      numReviews: 0,
    });
  }
};


/* -------------------------------------------------------
   ⭐ Create Review / Rating
--------------------------------------------------------*/
export const createFeedback = async (req, res) => {
  try {
    const { productId, rating, description } = req.body;
    const user = req.user;

    if (!productId || !rating) {
      return res.status(400).json({
        success: false,
        message: "Product ID and rating are required",
      });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: "Rating must be between 1 and 5",
      });
    }

    if (!user || !user._id || !user.name) {
      return res.status(401).json({
        success: false,
        message: "User information missing",
      });
    }

    // 🚫 Prevent duplicate review per user per product
    const existingReview = await Feedback.findOne({
      productId,
      userId: user._id,
    });

    if (existingReview) {
      return res.status(400).json({
        success: false,
        message: "You have already reviewed this product",
      });
    }

    const feedback = new Feedback({
      productId,
      userId: user._id,
      userName: user.name,
      userDisplay: user.astrologyProfile || "",
      rating,
      description,
    });

    await feedback.save();

    // ⭐ Update product rating stats
    await updateProductRating(productId);

    res.status(201).json({
      success: true,
      message: "Review submitted successfully",
      feedback,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: err.message });
  }
};


/* -------------------------------------------------------
   ⭐ Get Reviews for a Single Product
--------------------------------------------------------*/
export const getFeedbackByProduct = async (req, res) => {
  try {
    const { productId } = req.params;

    const feedbacks = await Feedback.find({ productId })
      .sort({ createdAt: -1 })
      .select("userName userDisplay rating description createdAt");

    res.status(200).json({ success: true, feedbacks });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};


/* -------------------------------------------------------
   ⭐ Admin: Get All Reviews
--------------------------------------------------------*/
export const getAllFeedbacks = async (req, res) => {
  try {
    const feedbacks = await Feedback.find()
      .sort({ createdAt: -1 })
      .populate("productId", "name averageRating numReviews")
      .populate("userId", "name email");

    res.status(200).json({ success: true, feedbacks });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
