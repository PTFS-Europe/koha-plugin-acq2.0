
describe("Acquisitions homepage", () => {
  beforeEach(() => {
    cy.login();
    cy.title().should("eq", "Koha staff interface");
  });

  it("Should redirect to the new acquisitions module", () => {
    cy.visit("/cgi-bin/koha/acqui/acqui-home.pl");
    cy.get("#acq2_homepage").contains("Homepage");
  });
});
