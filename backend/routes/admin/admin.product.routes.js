const router = require("express").Router();
const controller = require("../../controllers/admin/admin.product.controller");
const { authenticateToken } = require("../../middlewares/auth");
const admin = require("../../middlewares/admin.middleware");

router.use(authenticateToken);
router.use(admin);

// Product management
router.post("/", controller.createProduct);
router.get("/", controller.getAllProducts);
router.get("/:id", controller.getProductById);
router.put("/:id", controller.updateProduct);

// Delete handling
router.patch("/:id/deactivate", controller.deactivateProduct); // soft delete
router.delete("/:id", controller.deleteProductPermanent);      // hard delete

module.exports = router;
