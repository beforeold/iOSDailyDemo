const http = require("node:http");
const { simMiddleware } = require("serve-sim/middleware");

const port = Number(process.argv[2] || 3200);
const device = process.argv[3] || undefined;

const middleware = simMiddleware({
  basePath: "/",
  device
});

const server = http.createServer((request, response) => {
  middleware(request, response, () => {
    response.statusCode = 404;
    response.end("Not found");
  });
});

server.listen(port, "127.0.0.1", () => {
  console.log(`serve-sim preview listening at http://127.0.0.1:${port}`);
});
