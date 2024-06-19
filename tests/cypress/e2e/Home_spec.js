
describe("Acquisitions homepage", () => {
  beforeEach(() => {
    cy.login();
    cy.title().should("eq", "Koha staff interface");
    cy.intercept(
      "GET",
      "/api/v1/contrib/acquire/settings",
      [
        {
          "explanation": "Select which modules you wish to use in the acquisitions portal",
          "options": "",
          "type": "multiple",
          "value": "",
          "variable": "modulesEnabled"
        }
      ]
    );
  });

  it("Should redirect to the new acquisitions module", () => {
    cy.visit("/cgi-bin/koha/acqui/acqui-home.pl");
    cy.get("#acq2_homepage").contains("Homepage");
  });

  it("Should not have all modules available in the left hand menu", () => {
    cy.visit("/cgi-bin/koha/acqui/acqui-home.pl");
    cy.get("#navmenulist > h5").contains("Acquisitions");
    cy.get("#navmenulist > ul").children().should("have.length", 2);
    cy.get("#navmenulist > ul > li:nth-child(1) > span > a > span").contains("Tasks");
    cy.get("#navmenulist > ul > li:nth-child(2) > span > a > span").contains("Settings");
  })
});
