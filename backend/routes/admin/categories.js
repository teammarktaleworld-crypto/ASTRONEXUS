import express from "express";
import {
  createCategory,
  getAllCategories,
  updateCategory,
  toggleCategoryStatus
} from "../../controllers/admin/admin.category.controller.js";

const router = express.Router();

router.post("/", createCategory);
router.get("/", getAllCategories);
router.put("/:id", updateCategory);
router.patch("/:id/toggle", toggleCategoryStatus);

export default router;
