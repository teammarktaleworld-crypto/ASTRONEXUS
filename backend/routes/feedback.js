import express from "express";
import {
  createFeedback,
  getFeedbackByProduct,
  getAllFeedbacks
} from "../controllers/feedback.controller.js";
import { authenticateToken } from "../middlewares/auth.js";

const router = express.Router();

// Create feedback (authenticated)
router.post("/", authenticateToken, createFeedback);

// Get feedbacks for a product
router.get("/:productId", getFeedbackByProduct);

// Get all feedbacks (admin)
router.get("/", authenticateToken, getAllFeedbacks);

export default router;
