import HttpClient from "./http-client";

export class PatronAPIClient extends HttpClient {
    constructor() {
        super({
            baseURL: "/api/v1/contrib/acquire/",
        });
    }

    get patrons() {
        return {
            getPermittedPatrons: (query, params) => 
                this.get({
                    endpoint: "permitted_patrons",
                    query,
                    params,
                }),
        };
    }
}

export default PatronAPIClient;
