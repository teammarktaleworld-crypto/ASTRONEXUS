import Address from "../../models/shop/address.js";

// Get all addresses for the logged-in user
export const getUserAddresses = async (req, res) => {
  try {
    const addresses = await Address.find({ userId: req.userId });
    res.status(200).json(addresses);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Add a new address
export const addAddress = async (req, res) => {
  try {
    const newAddress = new Address({ userId: req.userId, ...req.body });

    // If setting as default, unset other defaults
    if (req.body.isDefault) {
      await Address.updateMany(
        { userId: req.user.id, isDefault: true },
        { isDefault: false }
      );
    }

    const savedAddress = await newAddress.save();
    res.status(201).json(savedAddress);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Update an address
export const updateAddress = async (req, res) => {
  try {
    const updated = await Address.findOneAndUpdate(
      { _id: req.params.addressId, userId: req.userId },
      req.body,
      { new: true }
    );
    if (!updated) return res.status(404).json({ message: "Address not found" });
    res.status(200).json(updated);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Delete an address
export const deleteAddress = async (req, res) => {
  try {
    const deleted = await Address.findOneAndDelete({
      _id: req.params.addressId,
      userId: req.userId,
    });
    if (!deleted) return res.status(404).json({ message: "Address not found" });
    res.status(200).json({ message: "Address deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


// Admin: get all addresses
export const getAllAddresses = async (req, res) => {
  try {
    const addresses = await Address.find().populate("userId", "fullName email"); 
    res.status(200).json(addresses);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

