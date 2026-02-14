import bcrypt from "bcryptjs";
import validator from "validator";
import User from "../../models/user.js";
import { createToken, createRefreshToken, verifyRefreshToken } from "../../service/auth.js";

/* ======================================================
   1️⃣ BASIC SIGNUP
====================================================== */
export async function handleBasicSignup(req, res) {
  try {
    const { name, phone, password, confirmPassword, email } = req.body;

    if (!name || !phone || !password || !confirmPassword) {
      return res.status(400).json({ error: "Name, phone and password are required" });
    }
    if (!validator.isMobilePhone(phone, "any")) {
      return res.status(400).json({ error: "Invalid phone number" });
    }
    if (email && !validator.isEmail(email)) {
      return res.status(400).json({ error: "Invalid email format" });
    }
    if (password.length < 6) {
      return res.status(400).json({ error: "Password must be at least 6 characters" });
    }
    if (password !== confirmPassword) {
      return res.status(400).json({ error: "Passwords do not match" });
    }

    const existingUser = await User.findOne({ $or: [{ phone }, { email }] });
    if (existingUser) return res.status(400).json({ error: "User already exists" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({ name, phone, email, password: hashedPassword });

    const token = createToken(user);
    const refreshToken = createRefreshToken(user);

    res.cookie("token", token, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 });
    res.cookie("refreshToken", refreshToken, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });

    res.status(201).json({
      success: true,
      message: "Basic signup successful",
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        sessionId: user.sessionId   // ⭐ added
      }
    });

  } catch (error) {
    console.error("Basic Signup Error:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

/* ======================================================
   2️⃣ ASTROLOGY SIGNUP (FULL PROFILE)
====================================================== */
export async function handleAstrologySignup(req, res) {
  try {
    const { name, phone, password, confirmPassword, email, dateOfBirth, timeOfBirth, placeOfBirth } = req.body;

    if (!dateOfBirth || !timeOfBirth || !placeOfBirth) {
      return res.status(400).json({ error: "Astrology birth details are required" });
    }
    if (!validator.isMobilePhone(phone, "any")) {
      return res.status(400).json({ error: "Invalid phone number" });
    }
    if (email && !validator.isEmail(email)) {
      return res.status(400).json({ error: "Invalid email format" });
    }
    if (password.length < 6) {
      return res.status(400).json({ error: "Password must be at least 6 characters" });
    }
    if (password !== confirmPassword) {
      return res.status(400).json({ error: "Passwords do not match" });
    }

    const existingUser = await User.findOne({ $or: [{ phone }, { email }] });
    if (existingUser) return res.status(400).json({ error: "User already exists" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      name,
      phone,
      email,
      password: hashedPassword,
      astrologyProfile: { dateOfBirth, timeOfBirth, placeOfBirth }
    });

    const token = createToken(user);
    const refreshToken = createRefreshToken(user);

    res.cookie("token", token, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 });
    res.cookie("refreshToken", refreshToken, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });

    res.status(201).json({
      success: true,
      message: "Astrology signup successful",
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        sessionId: user.sessionId,   // ⭐ added
        astrologyProfile: user.astrologyProfile
      }
    });

  } catch (error) {
    console.error("Astrology Signup Error:", error);
    res.status(500).json({ error: "Internal server error" });
  }
}

/* ======================================================
   USER LOGIN (EMAIL)
====================================================== */
export async function handleUserLogin(req, res) {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: "Email and password are required" });
    if (!validator.isEmail(email)) return res.status(400).json({ error: "Invalid email format" });

    const user = await User.findOne({ email }).select("+password +astrologyProfile");
    if (!user) return res.status(401).json({ error: "Invalid email or password" });
    if (user.isBlocked) return res.status(403).json({ error: "This account is blocked" });

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) return res.status(401).json({ error: "Invalid email or password" });

    user.lastLoginAt = new Date();
    await user.save();

    const token = createToken(user);
    const refreshToken = createRefreshToken(user);

    res.cookie("token", token, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 });
    res.cookie("refreshToken", refreshToken, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });

    return res.json({
      success: true,
      message: "Login successful",
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        isBlocked: user.isBlocked,
        lastLoginAt: user.lastLoginAt,
        sessionId: user.sessionId,  // ⭐ added
        astrologyProfile: user.astrologyProfile || null
      }
    });
  } catch (error) {
    console.error("Login error:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
}

/* ======================================================
   USER LOGIN (PHONE)
====================================================== */
export async function handleUserLoginWithPhone(req, res) {
  try {
    const { phone, password } = req.body;
    if (!phone || !password) return res.status(400).json({ error: "Phone and password are required" });
    if (!validator.isMobilePhone(phone, "any")) return res.status(400).json({ error: "Invalid phone number format" });

    const user = await User.findOne({ phone }).select("+password +astrologyProfile");
    if (!user) return res.status(401).json({ error: "Invalid phone or password" });
    if (user.isBlocked) return res.status(403).json({ error: "This account is blocked" });

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) return res.status(401).json({ error: "Invalid phone or password" });

    user.lastLoginAt = new Date();
    await user.save();

    const token = createToken(user);
    const refreshToken = createRefreshToken(user);

    res.cookie("token", token, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 });
    res.cookie("refreshToken", refreshToken, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });

    return res.json({
      success: true,
      message: "Login successful",
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        role: user.role,
        isBlocked: user.isBlocked,
        lastLoginAt: user.lastLoginAt,
        sessionId: user.sessionId,  // ⭐ added
        astrologyProfile: user.astrologyProfile || null
      }
    });
  } catch (error) {
    console.error("Login error:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
}

/* ======================================================
   REFRESH TOKEN
====================================================== */
export async function handleRefreshToken(req, res) {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) return res.status(401).json({ error: "No refresh token provided" });

    const userData = verifyRefreshToken(refreshToken);
    if (!userData) return res.status(401).json({ error: "Invalid refresh token" });

    const user = await User.findById(userData.id);
    if (!user) return res.status(404).json({ error: "User not found" });

    const newToken = createToken(user);
    const newRefreshToken = createRefreshToken(user);

    res.cookie("token", newToken, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 });
    res.cookie("refreshToken", newRefreshToken, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });

    return res.json({
      success: true,
      token: newToken,
      refreshToken: newRefreshToken,
      sessionId: user.sessionId   // ⭐ helpful for frontend re-sync
    });
  } catch (err) {
    console.error("Refresh token error:", err);
    return res.status(500).json({ error: "Internal server error" });
  }
}

/* ======================================================
   USER LOGOUT
====================================================== */
export async function handleUserLogout(req, res) {
  res.clearCookie("token");
  res.clearCookie("refreshToken");
  return res.json({ success: true, message: "Logged out successfully" });
}
