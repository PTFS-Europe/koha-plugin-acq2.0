import HttpClient from "./http-client";

export class AcquisitionAPIClient extends HttpClient {
    constructor() {
        super({
            baseURL: "/api/v1/contrib/acquire/",
        });
    }

    get settings() {
        return {
            getAll: (query, params) =>
                this.get({
                    endpoint: "settings",
                    query,
                    params,
                }),
            create: config =>
                this.post({
                    endpoint: "settings",
                    body: config,
                }),
        };
    }
}

export default AcquisitionAPIClient;
