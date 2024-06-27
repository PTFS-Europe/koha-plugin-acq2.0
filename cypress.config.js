const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    experimentalStudio: true,
    baseUrl: "http://localhost:8081",
    specPattern: "tests/cypress/specs/**/*.*",
    supportFile: "tests/cypress/support/e2e.js",
    video: false,
    screenshotOnRunFailure: false
  },
});
