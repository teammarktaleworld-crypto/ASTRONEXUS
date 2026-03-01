import express from "express";
import axios from "axios";

const router = express.Router();

const cleanBaseUrl = (value, fallback) => (value || fallback).replace(/\/+$/, "");

const serviceConfig = {
  birthchart: {
    baseUrl: () => cleanBaseUrl(process.env.PY_BIRTHCHART_BASE_URL, "http://localhost:8000"),
    endpoint: "/api/v1/chart",
    method: "POST"
  },
  horoscope: {
    baseUrl: () => cleanBaseUrl(process.env.PY_HOROSCOPE_BASE_URL, "http://localhost:4000"),
    endpoint: "/api/horoscope",
    method: "GET"
  },
  mati: {
    baseUrl: () => cleanBaseUrl(process.env.PY_MATI_BASE_URL, "http://localhost:3000"),
    endpoint: "/api/chat",
    method: "POST"
  }
};

const getPublicBaseUrl = (req) => {
  const forwardedProto = req.headers["x-forwarded-proto"];
  const protocol = forwardedProto || req.protocol || "http";
  return `${protocol}://${req.get("host")}`;
};

const pickForwardHeaders = (req) => {
  const headers = {
    "content-type": "application/json"
  };

  if (req.headers.authorization) {
    headers.authorization = req.headers.authorization;
  }

  return headers;
};

const proxyToService = async ({ req, res, serviceName, targetConfig }) => {
  try {
    const response = await axios({
      method: targetConfig.method,
      url: `${targetConfig.baseUrl()}${targetConfig.endpoint}`,
      params: req.query,
      data: req.body,
      headers: pickForwardHeaders(req),
      timeout: 30000,
      validateStatus: () => true
    });

    return res.status(response.status).json(response.data);
  } catch (error) {
    console.error(`Wrapper proxy error (${serviceName}):`, error.message);

    if (error.response) {
      return res.status(error.response.status).json(error.response.data);
    }

    return res.status(502).json({
      success: false,
      message: `Unable to reach ${serviceName} service`,
      error: error.message
    });
  }
};

router.get("/base", (req, res) => {
  const baseUrl = getPublicBaseUrl(req);

  res.json({
    success: true,
    baseUrl,
    wrapperBaseUrl: `${baseUrl}/api/wrapper`
  });
});

router.get("/services", (req, res) => {
  const baseUrl = getPublicBaseUrl(req);
  const wrapperBaseUrl = `${baseUrl}/api/wrapper`;

  res.json({
    success: true,
    wrapperBaseUrl,
    endpoints: {
      birthchart: {
        method: "POST",
        url: `${wrapperBaseUrl}/birthchart`,
        upstream: `${serviceConfig.birthchart.baseUrl()}${serviceConfig.birthchart.endpoint}`
      },
      horoscope: {
        method: "GET",
        url: `${wrapperBaseUrl}/horoscope`,
        upstream: `${serviceConfig.horoscope.baseUrl()}${serviceConfig.horoscope.endpoint}`
      },
      matiChat: {
        method: "POST",
        url: `${wrapperBaseUrl}/mati/chat`,
        upstream: `${serviceConfig.mati.baseUrl()}${serviceConfig.mati.endpoint}`
      }
    }
  });
});

router.post("/birthchart", async (req, res) => {
  return proxyToService({
    req,
    res,
    serviceName: "birthchart",
    targetConfig: serviceConfig.birthchart
  });
});

router.get("/horoscope", async (req, res) => {
  return proxyToService({
    req,
    res,
    serviceName: "horoscope",
    targetConfig: serviceConfig.horoscope
  });
});

router.post("/mati/chat", async (req, res) => {
  return proxyToService({
    req,
    res,
    serviceName: "mati",
    targetConfig: serviceConfig.mati
  });
});

export default router;
