import HttpClient from "./http-client";
// Renamed from AcquisitionAPIClient for this plugin as this only returns vendors
export class VendorAPIClient extends HttpClient {
    constructor() {
        super({
            baseURL: "/api/v1/acquisitions/",
        });
    }

    get vendors() {
        return {
            getAll: (query, params) =>
                this.get({
                    endpoint: "vendors",
                    query,
                    params,
                    headers: {
                        "x-koha-embed": "aliases",
                    },
                }),
        };
    }
}

export default VendorAPIClient;
