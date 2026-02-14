
import Order from "../../models/shop/Order.model.js";

export const getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find()
      .populate({ path: "items.product", select: "name price images" })
      .populate({ path: "user", select: "name email" })
      .sort({ createdAt: -1 });

    res.json({ success: true, count: orders.length, orders });
  } catch (err) {
    console.error("GET ALL ORDERS ERROR FULL:", err);
    res.status(500).json({ error: err.message });
  }
};

export const updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!id || !status) return res.status(400).json({ message: "ID and status required" });

    const updatedOrder = await Order.findByIdAndUpdate(id, { status }, { new: true })
      .populate("items.product", "name price images");

    if (!updatedOrder) return res.status(404).json({ message: "Order not found" });

    res.json({ success: true, order: updatedOrder });
  } catch (err) {
    console.error("UPDATE ORDER STATUS ERROR:", err);
    res.status(500).json({ message: "Failed to update order status" });
  }
};
