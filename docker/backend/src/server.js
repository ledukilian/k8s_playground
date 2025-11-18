import express from "express";
import cors from "cors";
import morgan from "morgan";

const app = express();
const PORT = process.env.PORT || 8080;

const featureToggles = (() => {
  try {
    return JSON.parse(process.env.FEATURE_TOGGLES || "{}");
  } catch (err) {
    console.warn("Impossible de parser FEATURE_TOGGLES", err);
    return {};
  }
})();

const config = {
  env: process.env.APP_ENV || "local",
  message: process.env.APP_MESSAGE || "Hello playground 👋",
  db: {
    host: process.env.DB_HOST || "postgres",
    port: Number(process.env.DB_PORT || "5432"),
    name: process.env.DB_NAME || "playground",
    user: process.env.DB_USER || "playground",
  },
};

let requestCount = 0;
let isReady = false;
setTimeout(() => {
  isReady = true;
}, 4000);

app.use(cors());
app.use(express.json());
app.use(morgan("tiny"));
app.use((req, _res, next) => {
  requestCount += 1;
  next();
});

app.get("/", (_req, res) => {
  res.json({
    message: config.message,
    env: config.env,
    timestamp: new Date().toISOString(),
    featureToggles,
  });
});

app.get("/message", (_req, res) => {
  res.json({ message: config.message });
});

app.get("/healthz", (_req, res) => {
  res.json({ status: "ok", uptime: process.uptime() });
});

app.get("/readyz", (_req, res) => {
  if (!isReady) {
    return res.status(503).json({ status: "starting" });
  }
  return res.json({ status: "ready" });
});

app.get("/metrics", (_req, res) => {
  res.type("text/plain").send(
    [
      `# HELP playground_requests_total Total requests served`,
      `# TYPE playground_requests_total counter`,
      `playground_requests_total ${requestCount}`,
      `# HELP playground_ready Gauge indiquant si l'app est ready`,
      `# TYPE playground_ready gauge`,
      `playground_ready ${isReady ? 1 : 0}`,
    ].join("\n"),
  );
});

app.get("/debug/slow", async (_req, res) => {
  if (!featureToggles.enableSlowEndpoint) {
    return res.status(404).json({ error: "slow endpoint disabled" });
  }
  await new Promise((resolve) => setTimeout(resolve, 5000));
  return res.json({ status: "ok", delay: "5000ms" });
});

app.get("/debug/error", (_req, res) => {
  if (!featureToggles.enableErrorEndpoint) {
    return res.status(404).json({ error: "error endpoint disabled" });
  }
  return res.status(500).json({ error: "Simulated failure" });
});

app.get("/debug/crash", (_req, res) => {
  if (!featureToggles.enableCrashEndpoint) {
    return res.status(404).json({ error: "crash endpoint disabled" });
  }
  res.json({ status: "bye" });
  setTimeout(() => process.exit(1), 300);
});

app.get("/test/log", (_req, res) => {
  console.log(`[test-log] ${new Date().toISOString()} – example log line`);
  res.json({ status: "logged" });
});

app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT} (env=${config.env})`);
});

