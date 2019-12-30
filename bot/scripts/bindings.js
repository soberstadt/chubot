const { Probot } = require("probot");
const app = require("../src/bot.js");

Probot.run(app);

module.exports = robot => {};
