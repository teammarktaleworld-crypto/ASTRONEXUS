// models/Wishlist.js
const mongoose = require('mongoose');

const wishlistSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  products: [{ type: String }] // store product IDs
}, { timestamps: true });

module.exports = mongoose.model('Wishlist', wishlistSchema);