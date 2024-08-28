// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

function get_fallback_login_value(param) {

    var env_var = param == 'username' ? 'KOHA_USER' : 'KOHA_PASS';

    return typeof Cypress.env(env_var) === 'undefined' ? 'koha' : Cypress.env(env_var);
}

Cypress.Commands.add('login', (username, password) => {
    var user = typeof username === 'undefined' ? get_fallback_login_value('username') : username;
    var pass = typeof password === 'undefined' ? get_fallback_login_value('password') : password;
    cy.visit('/cgi-bin/koha/mainpage.pl?logout.x=1')
    cy.get("#userid").type(user)
    cy.get("#password").type(pass)
    cy.get("#submit-button").click()
})

cy.getLibraryGroups = () => {
    return [
        {
            "sub_groups": [
                {
                    "is_sub_group": 1,
                    "title": "LibGroup1 SubGroupA",
                    "sub_groups": [
                        {
                            "sub_groups": [],
                            "title": "LibGroup1 SubGroupA SubGroup1",
                            "id": 3,
                            "libraries": [
                                {
                                    "ft_hide_patron_info": 0,
                                    "ft_acquisitions": 0,
                                    "branchcode": "FPL",
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_search_groups_staff": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_limit_item_editing": 0,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_local_float_group": 0,
                                    "created_on": "2024-06-28 09:26:42",
                                    "description": null,
                                    "parent_id": 3,
                                    "id": 9
                                }
                            ],
                            "is_sub_group": 1
                        },
                        {
                            "is_sub_group": 1,
                            "sub_groups": [],
                            "title": "LibGroup1 SubGroupA SubGroup2",
                            "id": 4,
                            "libraries": [
                                {
                                    "branchcode": "CPL",
                                    "ft_acquisitions": 0,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_staff": 0,
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_local_float_group": 0,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_limit_item_editing": 0,
                                    "ft_local_hold_group": 0,
                                    "id": 10,
                                    "parent_id": 4,
                                    "description": null,
                                    "created_on": "2024-06-28 09:26:42"
                                }
                            ]
                        }
                    ],
                    "libraries": [
                        {
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0,
                            "branchcode": "CPL",
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "id": 6,
                            "parent_id": 2,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "ft_local_float_group": 0,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0
                        },
                        {
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0,
                            "branchcode": "FPL",
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "parent_id": 2,
                            "id": 7,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "ft_local_float_group": 0
                        }
                    ],
                    "id": 2
                },
                {
                    "libraries": [
                        {
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0,
                            "branchcode": "CPL",
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_local_float_group": 0,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "parent_id": 5,
                            "id": 8
                        }
                    ],
                    "id": 5,
                    "sub_groups": [],
                    "title": "LibGroup1 SubGroupB",
                    "is_sub_group": 1
                }
            ],
            "title": "LibGroup1",
            "libraries": [
                {
                    "updated_on": "2024-06-28 09:26:42",
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "ft_acquisitions": 0,
                    "branchcode": "CPL",
                    "created_on": "2024-06-28 09:26:42",
                    "description": null,
                    "id": 6,
                    "parent_id": 2,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "ft_local_float_group": 0,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0
                },
                {
                    "updated_on": "2024-06-28 09:26:42",
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "ft_acquisitions": 0,
                    "branchcode": "FPL",
                    "created_on": "2024-06-28 09:26:42",
                    "description": null,
                    "parent_id": 2,
                    "id": 7,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "ft_local_float_group": 0
                }
            ],
            "id": 1
        },
        {
            "sub_groups": [
                {
                    "title": "LibGroup2 SubGroupA",
                    "sub_groups": [
                        {
                            "libraries": [
                                {
                                    "ft_local_float_group": 0,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_local_hold_group": 0,
                                    "ft_limit_item_editing": 0,
                                    "id": 25,
                                    "parent_id": 13,
                                    "created_on": "2024-06-28 09:26:42",
                                    "description": null,
                                    "branchcode": "MPL",
                                    "ft_hide_patron_info": 0,
                                    "ft_acquisitions": 0,
                                    "ft_search_groups_staff": 0,
                                    "updated_on": "2024-06-28 09:26:42"
                                }
                            ],
                            "id": 13,
                            "sub_groups": [],
                            "title": "LibGroup2 SubGroupA SubGroup1",
                            "is_sub_group": 1
                        },
                        {
                            "sub_groups": [],
                            "title": "LibGroup2 SubGroupA SubGroup2",
                            "libraries": [
                                {
                                    "ft_acquisitions": 0,
                                    "ft_hide_patron_info": 0,
                                    "branchcode": "CPL",
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_search_groups_staff": 0,
                                    "ft_limit_item_editing": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_local_float_group": 0,
                                    "description": null,
                                    "created_on": "2024-06-28 09:26:42",
                                    "id": 26,
                                    "parent_id": 14
                                }
                            ],
                            "id": 14,
                            "is_sub_group": 1
                        }
                    ],
                    "libraries": [
                        {
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0,
                            "branchcode": "CPL",
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "parent_id": 12,
                            "id": 19,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_local_float_group": 0
                        },
                        {
                            "ft_acquisitions": 0,
                            "ft_hide_patron_info": 0,
                            "branchcode": "MPL",
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_limit_item_editing": 0,
                            "ft_local_hold_group": 0,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "ft_local_float_group": 0,
                            "description": null,
                            "created_on": "2024-06-28 09:26:42",
                            "id": 20,
                            "parent_id": 12
                        }
                    ],
                    "id": 12,
                    "is_sub_group": 1
                },
                {
                    "sub_groups": [],
                    "title": "LibGroup2 SubGroupB",
                    "libraries": [
                        {
                            "id": 21,
                            "parent_id": 15,
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "ft_local_float_group": 0,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "updated_on": "2024-06-28 09:26:42",
                            "branchcode": "CPL",
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0
                        }
                    ],
                    "id": 15,
                    "is_sub_group": 1
                },
                {
                    "is_sub_group": 1,
                    "id": 16,
                    "libraries": [
                        {
                            "ft_limit_item_editing": 0,
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "parent_id": 16,
                            "id": 22,
                            "description": null,
                            "created_on": "2024-06-28 09:26:42",
                            "branchcode": "CPL",
                            "ft_acquisitions": 0,
                            "ft_hide_patron_info": 0,
                            "ft_search_groups_staff": 0,
                            "updated_on": "2024-06-28 09:26:42"
                        },
                        {
                            "description": null,
                            "created_on": "2024-06-28 09:26:42",
                            "id": 23,
                            "parent_id": 16,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_local_float_group": 0,
                            "ft_limit_item_editing": 0,
                            "ft_local_hold_group": 0,
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_acquisitions": 0,
                            "ft_hide_patron_info": 0,
                            "branchcode": "MPL"
                        },
                        {
                            "id": 24,
                            "parent_id": 16,
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "ft_local_float_group": 0,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "ft_search_groups_staff": 0,
                            "updated_on": "2024-06-28 09:26:42",
                            "branchcode": "TPL",
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0
                        }
                    ],
                    "sub_groups": [
                        {
                            "is_sub_group": 1,
                            "libraries": [
                                {
                                    "description": null,
                                    "created_on": "2024-06-28 09:26:42",
                                    "id": 27,
                                    "parent_id": 17,
                                    "ft_limit_item_editing": 0,
                                    "ft_local_hold_group": 0,
                                    "title": null,
                                    "ft_search_groups_opac": 0,
                                    "ft_local_float_group": 0,
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_search_groups_staff": 0,
                                    "ft_acquisitions": 0,
                                    "ft_hide_patron_info": 0,
                                    "branchcode": "MPL"
                                }
                            ],
                            "id": 17,
                            "title": "LibGroup2 SubGroupC SubGroup1",
                            "sub_groups": []
                        },
                        {
                            "is_sub_group": 1,
                            "sub_groups": [],
                            "title": "LibGroup2 SubGroupC SubGroup2",
                            "id": 18,
                            "libraries": [
                                {
                                    "ft_limit_item_editing": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_local_float_group": 0,
                                    "description": null,
                                    "created_on": "2024-06-28 09:26:42",
                                    "id": 28,
                                    "parent_id": 18,
                                    "ft_acquisitions": 0,
                                    "ft_hide_patron_info": 0,
                                    "branchcode": "CPL",
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_search_groups_staff": 0
                                },
                                {
                                    "ft_hide_patron_info": 0,
                                    "ft_acquisitions": 0,
                                    "branchcode": "TPL",
                                    "updated_on": "2024-06-28 09:26:42",
                                    "ft_search_groups_staff": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_limit_item_editing": 0,
                                    "title": null,
                                    "ft_search_groups_opac": 0,
                                    "ft_local_float_group": 0,
                                    "created_on": "2024-06-28 09:26:42",
                                    "description": null,
                                    "id": 29,
                                    "parent_id": 18
                                }
                            ]
                        }
                    ],
                    "title": "LibGroup2 SubGroupC"
                }
            ],
            "title": "LibGroup2",
            "id": 11,
            "libraries": [
                {
                    "updated_on": "2024-06-28 09:26:42",
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "ft_acquisitions": 0,
                    "branchcode": "CPL",
                    "created_on": "2024-06-28 09:26:42",
                    "description": null,
                    "parent_id": 12,
                    "id": 19,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0,
                    "ft_search_groups_opac": 0,
                    "title": null,
                    "ft_local_float_group": 0
                },
                {
                    "ft_acquisitions": 0,
                    "ft_hide_patron_info": 0,
                    "branchcode": "MPL",
                    "updated_on": "2024-06-28 09:26:42",
                    "ft_search_groups_staff": 0,
                    "ft_limit_item_editing": 0,
                    "ft_local_hold_group": 0,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "ft_local_float_group": 0,
                    "description": null,
                    "created_on": "2024-06-28 09:26:42",
                    "id": 20,
                    "parent_id": 12
                },
                {
                    "id": 24,
                    "parent_id": 16,
                    "created_on": "2024-06-28 09:26:42",
                    "description": null,
                    "ft_local_float_group": 0,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0,
                    "ft_search_groups_staff": 0,
                    "updated_on": "2024-06-28 09:26:42",
                    "branchcode": "TPL",
                    "ft_hide_patron_info": 0,
                    "ft_acquisitions": 0
                }
            ]
        },
        {
            "libraries": [
                {
                    "updated_on": "2024-06-28 09:26:42",
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "ft_acquisitions": 0,
                    "branchcode": "FFL",
                    "created_on": "2024-06-28 09:26:42",
                    "description": null,
                    "parent_id": 31,
                    "id": 32,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "ft_local_float_group": 0
                }
            ],
            "id": 30,
            "sub_groups": [
                {
                    "is_sub_group": 1,
                    "id": 31,
                    "libraries": [
                        {
                            "updated_on": "2024-06-28 09:26:42",
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "ft_acquisitions": 0,
                            "branchcode": "FFL",
                            "created_on": "2024-06-28 09:26:42",
                            "description": null,
                            "parent_id": 31,
                            "id": 32,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "ft_local_float_group": 0
                        }
                    ],
                    "title": "LibGroup3 SubGroupA",
                    "sub_groups": []
                }
            ],
            "title": "LibGroup3"
        }
    ]
}
