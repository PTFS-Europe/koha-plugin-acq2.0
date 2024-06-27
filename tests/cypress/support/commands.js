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
            "id": 1,
            "sub_groups": [
                {
                    "id": 2,
                    "is_sub_group": 1,
                    "sub_groups": [
                        {
                            "sub_groups": [],
                            "is_sub_group": 1,
                            "id": 3,
                            "libraries": [
                                {
                                    "branchcode": "FPL",
                                    "id": 9,
                                    "ft_search_groups_opac": 0,
                                    "title": null,
                                    "ft_search_groups_staff": 0,
                                    "ft_hide_patron_info": 0,
                                    "description": null,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "parent_id": 3,
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "ft_acquisitions": 0,
                                    "ft_limit_item_editing": 0,
                                    "created_on": "2024-06-27 13:36:58"
                                }
                            ],
                            "title": "LibGroup1 SubGroupA SubGroup1"
                        },
                        {
                            "is_sub_group": 1,
                            "sub_groups": [],
                            "id": 4,
                            "title": "LibGroup1 SubGroupA SubGroup2",
                            "libraries": [
                                {
                                    "ft_search_groups_opac": 0,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_staff": 0,
                                    "title": null,
                                    "branchcode": "CPL",
                                    "id": 10,
                                    "description": null,
                                    "parent_id": 4,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "created_on": "2024-06-27 13:36:58",
                                    "ft_limit_item_editing": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "ft_acquisitions": 0
                                }
                            ]
                        }
                    ],
                    "libraries": [
                        {
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 2,
                            "ft_acquisitions": 0,
                            "ft_local_float_group": 0,
                            "ft_local_hold_group": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "branchcode": "CPL",
                            "id": 6,
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "description": null
                        },
                        {
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 2,
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_acquisitions": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "ft_limit_item_editing": 0,
                            "id": 7,
                            "branchcode": "FPL",
                            "ft_hide_patron_info": 0,
                            "ft_search_groups_staff": 0,
                            "title": null,
                            "ft_search_groups_opac": 0,
                            "description": null
                        }
                    ],
                    "title": "LibGroup1 SubGroupA"
                },
                {
                    "id": 5,
                    "sub_groups": [],
                    "is_sub_group": 1,
                    "libraries": [
                        {
                            "ft_acquisitions": 0,
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 5,
                            "description": null,
                            "id": 8,
                            "branchcode": "CPL",
                            "ft_search_groups_opac": 0,
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "title": null
                        }
                    ],
                    "title": "LibGroup1 SubGroupB"
                }
            ],
            "title": "LibGroup1",
            "libraries": [
                {
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 2,
                    "ft_acquisitions": 0,
                    "ft_local_float_group": 0,
                    "ft_local_hold_group": 0,
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "branchcode": "CPL",
                    "id": 6,
                    "ft_search_groups_opac": 0,
                    "title": null,
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "description": null
                },
                {
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 2,
                    "ft_local_hold_group": 0,
                    "ft_local_float_group": 0,
                    "ft_acquisitions": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "ft_limit_item_editing": 0,
                    "id": 7,
                    "branchcode": "FPL",
                    "ft_hide_patron_info": 0,
                    "ft_search_groups_staff": 0,
                    "title": null,
                    "ft_search_groups_opac": 0,
                    "description": null
                },
                {
                    "ft_acquisitions": 0,
                    "ft_local_hold_group": 0,
                    "ft_local_float_group": 0,
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 5,
                    "description": null,
                    "id": 8,
                    "branchcode": "CPL",
                    "ft_search_groups_opac": 0,
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "title": null
                }
            ]
        },
        {
            "title": "LibGroup2",
            "libraries": [
                {
                    "parent_id": 12,
                    "updated_on": "2024-06-27 13:36:58",
                    "created_on": "2024-06-27 13:36:58",
                    "ft_limit_item_editing": 0,
                    "ft_local_float_group": 0,
                    "ft_local_hold_group": 0,
                    "ft_acquisitions": 0,
                    "ft_hide_patron_info": 0,
                    "title": null,
                    "ft_search_groups_staff": 0,
                    "ft_search_groups_opac": 0,
                    "id": 19,
                    "branchcode": "CPL",
                    "description": null
                },
                {
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 12,
                    "ft_local_hold_group": 0,
                    "ft_local_float_group": 0,
                    "ft_acquisitions": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "ft_limit_item_editing": 0,
                    "id": 20,
                    "branchcode": "MPL",
                    "ft_search_groups_opac": 0,
                    "title": null,
                    "ft_hide_patron_info": 0,
                    "ft_search_groups_staff": 0,
                    "description": null
                },
                {
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 15,
                    "ft_local_hold_group": 0,
                    "ft_local_float_group": 0,
                    "ft_acquisitions": 0,
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "branchcode": "CPL",
                    "id": 21,
                    "ft_search_groups_opac": 0,
                    "ft_hide_patron_info": 0,
                    "title": null,
                    "ft_search_groups_staff": 0,
                    "description": null
                },
                {
                    "ft_local_hold_group": 0,
                    "ft_local_float_group": 0,
                    "ft_acquisitions": 0,
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 16,
                    "description": null,
                    "branchcode": "CPL",
                    "id": 22,
                    "title": null,
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "ft_search_groups_opac": 0
                },
                {
                    "updated_on": "2024-06-27 13:36:58",
                    "parent_id": 16,
                    "ft_local_hold_group": 0,
                    "ft_acquisitions": 0,
                    "ft_local_float_group": 0,
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "id": 23,
                    "branchcode": "MPL",
                    "ft_search_groups_opac": 0,
                    "ft_hide_patron_info": 0,
                    "ft_search_groups_staff": 0,
                    "title": null,
                    "description": null
                },
                {
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "ft_local_float_group": 0,
                    "ft_acquisitions": 0,
                    "ft_local_hold_group": 0,
                    "parent_id": 16,
                    "updated_on": "2024-06-27 13:36:58",
                    "description": null,
                    "ft_hide_patron_info": 0,
                    "title": null,
                    "ft_search_groups_staff": 0,
                    "ft_search_groups_opac": 0,
                    "branchcode": "TPL",
                    "id": 24
                }
            ],
            "sub_groups": [
                {
                    "title": "LibGroup2 SubGroupA",
                    "libraries": [
                        {
                            "parent_id": 12,
                            "updated_on": "2024-06-27 13:36:58",
                            "created_on": "2024-06-27 13:36:58",
                            "ft_limit_item_editing": 0,
                            "ft_local_float_group": 0,
                            "ft_local_hold_group": 0,
                            "ft_acquisitions": 0,
                            "ft_hide_patron_info": 0,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "ft_search_groups_opac": 0,
                            "id": 19,
                            "branchcode": "CPL",
                            "description": null
                        },
                        {
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 12,
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_acquisitions": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "ft_limit_item_editing": 0,
                            "id": 20,
                            "branchcode": "MPL",
                            "ft_search_groups_opac": 0,
                            "title": null,
                            "ft_hide_patron_info": 0,
                            "ft_search_groups_staff": 0,
                            "description": null
                        }
                    ],
                    "is_sub_group": 1,
                    "sub_groups": [
                        {
                            "id": 13,
                            "is_sub_group": 1,
                            "sub_groups": [],
                            "title": "LibGroup2 SubGroupA SubGroup1",
                            "libraries": [
                                {
                                    "branchcode": "MPL",
                                    "id": 25,
                                    "ft_search_groups_staff": 0,
                                    "title": null,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_opac": 0,
                                    "description": null,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "parent_id": 13,
                                    "ft_acquisitions": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "created_on": "2024-06-27 13:36:58",
                                    "ft_limit_item_editing": 0
                                }
                            ]
                        },
                        {
                            "title": "LibGroup2 SubGroupA SubGroup2",
                            "libraries": [
                                {
                                    "ft_limit_item_editing": 0,
                                    "created_on": "2024-06-27 13:36:58",
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "ft_acquisitions": 0,
                                    "parent_id": 14,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "description": null,
                                    "ft_hide_patron_info": 0,
                                    "title": null,
                                    "ft_search_groups_staff": 0,
                                    "ft_search_groups_opac": 0,
                                    "branchcode": "CPL",
                                    "id": 26
                                }
                            ],
                            "is_sub_group": 1,
                            "sub_groups": [],
                            "id": 14
                        }
                    ],
                    "id": 12
                },
                {
                    "title": "LibGroup2 SubGroupB",
                    "libraries": [
                        {
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 15,
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_acquisitions": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "branchcode": "CPL",
                            "id": 21,
                            "ft_search_groups_opac": 0,
                            "ft_hide_patron_info": 0,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "description": null
                        }
                    ],
                    "id": 15,
                    "is_sub_group": 1,
                    "sub_groups": []
                },
                {
                    "title": "LibGroup2 SubGroupC",
                    "libraries": [
                        {
                            "ft_local_hold_group": 0,
                            "ft_local_float_group": 0,
                            "ft_acquisitions": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 16,
                            "description": null,
                            "branchcode": "CPL",
                            "id": 22,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "ft_search_groups_opac": 0
                        },
                        {
                            "updated_on": "2024-06-27 13:36:58",
                            "parent_id": 16,
                            "ft_local_hold_group": 0,
                            "ft_acquisitions": 0,
                            "ft_local_float_group": 0,
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "id": 23,
                            "branchcode": "MPL",
                            "ft_search_groups_opac": 0,
                            "ft_hide_patron_info": 0,
                            "ft_search_groups_staff": 0,
                            "title": null,
                            "description": null
                        },
                        {
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "ft_local_float_group": 0,
                            "ft_acquisitions": 0,
                            "ft_local_hold_group": 0,
                            "parent_id": 16,
                            "updated_on": "2024-06-27 13:36:58",
                            "description": null,
                            "ft_hide_patron_info": 0,
                            "title": null,
                            "ft_search_groups_staff": 0,
                            "ft_search_groups_opac": 0,
                            "branchcode": "TPL",
                            "id": 24
                        }
                    ],
                    "id": 16,
                    "sub_groups": [
                        {
                            "title": "LibGroup2 SubGroupC SubGroup1",
                            "libraries": [
                                {
                                    "created_on": "2024-06-27 13:36:58",
                                    "ft_limit_item_editing": 0,
                                    "ft_local_float_group": 0,
                                    "ft_acquisitions": 0,
                                    "ft_local_hold_group": 0,
                                    "parent_id": 17,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "description": null,
                                    "title": null,
                                    "ft_search_groups_staff": 0,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_opac": 0,
                                    "branchcode": "MPL",
                                    "id": 27
                                }
                            ],
                            "id": 17,
                            "is_sub_group": 1,
                            "sub_groups": []
                        },
                        {
                            "title": "LibGroup2 SubGroupC SubGroup2",
                            "libraries": [
                                {
                                    "branchcode": "CPL",
                                    "id": 28,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_staff": 0,
                                    "title": null,
                                    "ft_search_groups_opac": 0,
                                    "description": null,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "parent_id": 18,
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "ft_acquisitions": 0,
                                    "ft_limit_item_editing": 0,
                                    "created_on": "2024-06-27 13:36:58"
                                },
                                {
                                    "parent_id": 18,
                                    "updated_on": "2024-06-27 13:36:58",
                                    "ft_limit_item_editing": 0,
                                    "created_on": "2024-06-27 13:36:58",
                                    "ft_acquisitions": 0,
                                    "ft_local_hold_group": 0,
                                    "ft_local_float_group": 0,
                                    "title": null,
                                    "ft_hide_patron_info": 0,
                                    "ft_search_groups_staff": 0,
                                    "ft_search_groups_opac": 0,
                                    "id": 29,
                                    "branchcode": "TPL",
                                    "description": null
                                }
                            ],
                            "id": 18,
                            "is_sub_group": 1,
                            "sub_groups": []
                        }
                    ],
                    "is_sub_group": 1
                }
            ],
            "id": 11
        },
        {
            "title": "LibGroup3",
            "libraries": [
                {
                    "ft_limit_item_editing": 0,
                    "created_on": "2024-06-27 13:36:58",
                    "ft_local_float_group": 0,
                    "ft_local_hold_group": 0,
                    "ft_acquisitions": 0,
                    "parent_id": 31,
                    "updated_on": "2024-06-27 13:36:58",
                    "description": null,
                    "ft_search_groups_opac": 0,
                    "ft_search_groups_staff": 0,
                    "ft_hide_patron_info": 0,
                    "title": null,
                    "id": 32,
                    "branchcode": "FFL"
                }
            ],
            "id": 30,
            "sub_groups": [
                {
                    "id": 31,
                    "sub_groups": [],
                    "is_sub_group": 1,
                    "title": "LibGroup3 SubGroupA",
                    "libraries": [
                        {
                            "ft_limit_item_editing": 0,
                            "created_on": "2024-06-27 13:36:58",
                            "ft_local_float_group": 0,
                            "ft_local_hold_group": 0,
                            "ft_acquisitions": 0,
                            "parent_id": 31,
                            "updated_on": "2024-06-27 13:36:58",
                            "description": null,
                            "ft_search_groups_opac": 0,
                            "ft_search_groups_staff": 0,
                            "ft_hide_patron_info": 0,
                            "title": null,
                            "id": 32,
                            "branchcode": "FFL"
                        }
                    ]
                }
            ]
        }
    ]
}
