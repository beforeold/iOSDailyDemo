const { execFileSync, spawn } = require("node:child_process");
const fs = require("node:fs");
const path = require("node:path");

const port = process.argv[2] || "3200";
const logPath = process.argv[3] || "/private/tmp/DemoServerSimServeSimPreview.log";
const pidPath = process.argv[4] || "/private/tmp/DemoServerSimServeSimPreview.pid";
const device = process.argv[5] || "";
const scriptPath = path.join(__dirname, "serve-sim-preview.cjs");
const globalNodeModules = execFileSync("npm", ["root", "-g"], {
  encoding: "utf8"
}).trim();

fs.mkdirSync(path.dirname(logPath), { recursive: true });

const log = fs.openSync(logPath, "a");
const child = spawn(process.execPath, [scriptPath, port, device], {
  detached: true,
  env: {
    ...process.env,
    NODE_PATH: [globalNodeModules, process.env.NODE_PATH].filter(Boolean).join(":")
  },
  stdio: ["ignore", log, log]
});

child.unref();
fs.writeFileSync(pidPath, `${child.pid}\n`);
console.log(child.pid);
