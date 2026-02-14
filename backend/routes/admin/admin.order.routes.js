const router = require("express").Router();
const c = require("../../controllers/admin/admin.order.controller");
const { authenticateToken } = require("../../middlewares/auth.js");
const admin = require("../../middlewares/admin.middleware.js");

// Apply auth + admin middleware to all admin order routes
router.use(authenticateToken, admin);

// GET all orders (admin)
router.get("/all", c.getAllOrders);

// UPDATE order status
router.put("/orders/:id/status", c.updateStatus);

module.exports = router;
