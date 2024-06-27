describe("Acquisitions settings", () => {
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

    it("Should load the settings homepage", () => {
        cy.visit("/acquisitions/settings");
        cy.get("h1").contains("Settings");
    });

    it("Should only show active modules and base modules", () => {
        cy.visit("/acquisitions/settings");
        cy.get(".navPanesGrid").children().should("have.length", 3);
        cy.get(".navPanesGrid > a:nth-child(1) > span").contains("General");
        cy.get(".navPanesGrid > a:nth-child(2) > span").contains("Task management");
        cy.get(".navPanesGrid > a:nth-child(3) > span").contains("Manual");
    })

    it("Should show module settings in each Module", () => {
        // We'll use the general module for testing
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
        cy.get("h1").contains("General settings");
        cy.get("#settingsList").children().should("have.length", 1);
        cy.get("#settingsList > li:nth-child(1) > label").contains("modulesEnabled:");
    })

});

describe("Acquisitions settings for a user with no settings permissions", () => {
    beforeEach(() => {
        cy.login('CPLmanage_budgets', 'Test1234');
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

    it("Should only show the manual", () => {
        cy.visit("/acquisitions/settings");
        cy.get(".navPanesGrid").children().should("have.length", 1);
        cy.get(".navPanesGrid > a:nth-child(1) > span").contains("Manual");
    })
})