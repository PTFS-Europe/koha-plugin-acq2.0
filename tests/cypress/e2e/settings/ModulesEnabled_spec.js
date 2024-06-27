
describe("modulesEnabled", () => {
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

    it("Should correctly show the modules in modulesEnabled settings", () => {
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
        cy.visit("/acquisitions/settings/general");
        cy.get("#modulesEnabled").find(".vs__actions").click();
        cy.get("#modulesEnabled").find("li").as("options");
        cy.get("@options").should("have.length", 1);

        cy.get("#modulesEnabled .vs__open-indicator").click();
        cy.get("#modulesEnabled .vs__dropdown-menu li:first").should(
            "have.text",
            "Funds and ledgers"
        );
    })

    it("Should show newly selected modules on the settings homepage", () => {
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
        cy.visit("/acquisitions/settings/general");
        cy.get("#modulesEnabled .vs__search").type(
            "Funds and ledgers" + "{enter}",
            { force: true }
        );

        cy.intercept(
            "GET",
            "/api/v1/contrib/acquire/settings",
            [
                {
                    "explanation": "Select which modules you wish to use in the acquisitions portal",
                    "options": "",
                    "type": "multiple",
                    "value": "funds",
                    "variable": "modulesEnabled"
                }
            ]
        );
        cy.get("#settingsForm > fieldset.action > input[type=submit]").click();

        //Should navigate back to the settings homepage and show the new module
        cy.get("h1").contains("Settings");
        cy.get(".navPanesGrid").children().should("have.length", 4);
        cy.get(".navPanesGrid > a:nth-child(3) > span").contains("Funds and ledgers");
    })

    it("Should show newly selected modules in the left hand menu", () => {
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
        cy.visit("/acquisitions/settings/general");
        cy.get("#modulesEnabled .vs__search").type(
            "Funds and ledgers" + "{enter}",
            { force: true }
        );

        cy.intercept(
            "GET",
            "/api/v1/contrib/acquire/settings",
            [
                {
                    "explanation": "Select which modules you wish to use in the acquisitions portal",
                    "options": "",
                    "type": "multiple",
                    "value": "funds",
                    "variable": "modulesEnabled"
                }
            ]
        );
        cy.get("#settingsForm > fieldset.action > input[type=submit]").click();

        //Should navigate back to the settings homepage and include the new module in the left hand menu
        cy.get("h1").contains("Settings");
        cy.get("#navmenulist > h5").contains("Acquisitions");
        cy.get("#navmenulist > ul").children().should("have.length", 3);
        cy.get("#navmenulist > ul > li:nth-child(1) > span > a > span").contains("Funds and ledgers");
        cy.get("#navmenulist > ul > li:nth-child(2) > span > a > span").contains("Tasks");
        cy.get("#navmenulist > ul > li:nth-child(3) > span > a > span").contains("Settings");
    })
});