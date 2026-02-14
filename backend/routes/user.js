import express from "express";
import { authenticateToken , authorizeAdmin} from "../middlewares/auth.js";

import {
  handleBasicSignup,
  handleAstrologySignup,
  handleUserLogin,
  handleUserLogout,
  handleUserLoginWithPhone // ✅ import the new phone login
} from "../controllers/users/user.js";

import * as categoryController from "../controllers/users/category.controller.js";
import * as productController from "../controllers/users/product.controller.js";
import * as cartController from "../controllers/users/cart.controller.js";
import * as orderController from "../controllers/users/orderController.js";
import * as paymentController from "../controllers/users/payment.controller.js";
import * as addressController from "../controllers/users/address.controller.js";


const router = express.Router();

// ================== AUTH ROUTES ==================
router.post("/signup/basic", handleBasicSignup);          // Step 1 signup
router.post("/signup/astrology", handleAstrologySignup);  // Full astrology signup
router.post("/login", handleUserLogin);                   // login by email
router.post("/login/phone", handleUserLoginWithPhone);   // login by phone
router.post("/logout", authenticateToken, handleUserLogout);

// ================== CATEGORY ROUTES ==================
router.get("/categories", categoryController.getActiveCategories);

// ================== PRODUCT ROUTES ==================
router.get("/products", productController.getProducts);
router.get("/products/:productId", productController.getProductById);

// ================== CART ROUTES ==================
router.get("/cart", authenticateToken, cartController.getCart);
router.post("/cart/add", authenticateToken, cartController.addToCart);
router.put("/cart/update", authenticateToken, cartController.updateCartItem);
router.delete("/cart/remove/:productId", authenticateToken, cartController.removeItem);

// ================== ORDER ROUTES ==================
router.post("/orders", authenticateToken, orderController.placeOrder);
router.get("/orders/my", authenticateToken, orderController.getUserOrders);
router.get("/orders/:orderId", authenticateToken, orderController.getOrderById);


// Admin route
router.get("/addresses/all", authenticateToken, authorizeAdmin, addressController.getAllAddresses);

//Address

router.get("/addresses", authenticateToken, addressController.getUserAddresses);
router.post("/addresses/add", authenticateToken, addressController.addAddress);
router.put("/addresses/:addressId", authenticateToken, addressController.updateAddress);
router.delete("/addresses/:addressId", authenticateToken, addressController.deleteAddress);


// ================== PAYMENT ROUTES ==================
router.post("/payment/create", authenticateToken, paymentController.createPayment);
router.post("/payment/verify", authenticateToken, paymentController.verifyPayment);

console.log("User routes loaded");

export default router;
