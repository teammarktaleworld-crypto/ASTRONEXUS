// controllers/users/wishlistController.js
import Wishlist from '../../models/shop/Wishlist.js';
import Product from '../../models/shop/Product.model.js'; // Your Product model

// Add or update wishlist
export const addWishlist = async (req, res) => {
  try {
    const userId = req.userId; // <-- from authenticateToken middleware
    const { products } = req.body;

    if (!products || !Array.isArray(products)) {
      return res.status(400).json({ error: 'Products array is required' });
    }

    let wishlist = await Wishlist.findOne({ userId });
    if (wishlist) {
      wishlist.products = products; // overwrite products
      await wishlist.save();
    } else {
      wishlist = new Wishlist({ userId, products });
      await wishlist.save();
    }

    res.status(200).json(wishlist);
  } catch (err) {
    console.error("Add wishlist error:", err);
    res.status(400).json({ error: err.message });
  }
};

// Get wishlist with full product details
export const getWishlist = async (req, res) => {
  try {
    const userId = req.userId;
    const wishlist = await Wishlist.findOne({ userId });

    if (!wishlist || wishlist.products.length === 0) {
      return res.status(200).json({ products: [] });
    }

    const products = await Product.find({
      _id: { $in: wishlist.products },
      isActive: true,
      isDeleted: false
    }).select('name images price astrologyType stock deliveryType');

    res.status(200).json({ products });
  } catch (err) {
    console.error("Get wishlist error:", err);
    res.status(400).json({ error: err.message });
  }
};

// Remove a product from wishlist
export const removeProduct = async (req, res) => {
  try {
    const userId = req.userId;
    const { productId } = req.body;

    if (!productId) {
      return res.status(400).json({ error: "Product ID is required" });
    }

    const wishlist = await Wishlist.findOne({ userId });
    if (!wishlist) return res.status(404).json({ error: 'Wishlist not found' });

    wishlist.products = wishlist.products.filter(p => p !== productId);
    await wishlist.save();

    res.status(200).json(wishlist);
  } catch (err) {
    console.error("Remove wishlist product error:", err);
    res.status(400).json({ error: err.message });
  }
};