//
//  ForgotPassword.swift
//  TestMerge
//
//  Created by Yogesh on 1/15/26.
//

import SwiftUI

struct OrdersListView: View {

    let response: OrdersAPIModel

    var body: some View {
        NavigationView {
            List {
                if let orders = response.data?.orders?.data {
                    ForEach(orders.indices, id: \.self) { index in
                        let order = orders[index]

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Order ID: \(order.orderId ?? "-")")
                                .font(.headline)

                            Text("BOL: \(order.blnum ?? "-")")
                                .font(.subheadline)

                            Text("Status: \(order.status ?? "-")")
                                .font(.caption)

                            Text("Commodity: \(order.commodity ?? "-")")
                                .font(.caption)
                        }
                        .padding(.vertical, 6)
                    }
                } else {
                    Text("No orders available")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Orders")
        }
    }
}




final class OrdersAPIModel: Codable {

    let success: Bool?
    let data: DataContainer?
    let message: String?

    struct DataContainer: Codable {
        let orders: OrdersContainer?
        let selectedColumns: [SelectedColumn]?
        let widgets: Widgets?
    }

    struct OrdersContainer: Codable {
        let data: [Order]?
        let meta: Meta?
    }

    struct Meta: Codable {
        let total: Int?
        let lastPage: Int?
        let currentPage: Int?
        let perPage: Int?
        let prev: Int?
        let next: Int?
    }

    struct Order: Codable {
        let id: Int?
        let uuid: String?
        let orderId: String?
        let orderTypeId: String?
        let enteredUserId: String?
        let equipmentTypeId: String?
        let currMovementId: String?
        let temperatureMin: Int?
        let temperatureMax: Int?
        let setpointTemp: Int?
        let pieces: Int?
        let billDistance: Int?
        let blnum: String?
        let freightCharge: Double?
        let orderedDate: String?
        let status: String?

        let trailer: Trailer?
        let currentMovement: Movement?
        let pickupStop: Stop?
        let deliveryStop: Stop?
        let datalakeIOTData: [IOTData]?

        let commodity: String?
        let dslyTrackingdeviceid: String?
        let dslyTrackingplatform: String?
        let customer: [Customer]?
        let stops: [StopDetail]?

        enum CodingKeys: String, CodingKey {
            case id, uuid, orderId, orderTypeId, enteredUserId
            case equipmentTypeId, currMovementId
            case temperatureMin, temperatureMax, setpointTemp
            case pieces, billDistance, blnum
            case freightCharge
            case orderedDate, status
            case trailer
            case currentMovement
            case pickupStop
            case deliveryStop
            case datalakeIOTData = "DatalakeIOTData"
            case commodity
            case dslyTrackingdeviceid
            case dslyTrackingplatform
            case customer
            case stops
        }
    }

    struct Trailer: Codable {
        let id: Int?
        let uuid: String?
        let assetId: String?
        let assetName: String?
        let temperature: Double?
        let latitude: Double?
        let longitude: Double?
        let battery: Int?
        let lastLocation: String?
        let lastReportDate: String?
    }

    struct Movement: Codable {
        let id: Int?
        let uuid: String?
        let mcleodMovementId: String?
        let brokerageStatus: String?
        let nextSchedCall: String?
        let carrier: Carrier?

        enum CodingKeys: String, CodingKey {
            case id, uuid, mcleodMovementId
            case brokerageStatus
            case nextSchedCall
            case carrier = "Carrier"
        }
    }

    struct Carrier: Codable {
        let id: Int?
        let uuid: String?
        let name: String?
        let city: String?
        let state: String?
        let zipCode: String?
    }

    struct Stop: Codable {
        let id: Int?
        let uuid: String?
        let schedArriveEarly: String?
        let schedArriveLate: String?
        let latitude: Double?
        let longitude: Double?
        let locationName: String?
        let cityName: String?
        let state: String?
    }

    struct StopDetail: Codable {
        let id: Int?
        let cityName: String?
        let state: String?
        let stopType: String?
        let schedArriveEarly: String?
        let schedArriveLate: String?
    }

    struct IOTData: Codable {
        let id: Int?
        let temperature: Double?
        let latitude: Double?
        let longitude: Double?
        let address1: String?
        let modified: String?
    }

    struct Customer: Codable {
        let id: Int?
        let uuid: String?
        let customerId: String?
        let name: String?
    }

    struct SelectedColumn: Codable {
        let columnName: String?
        let columnValue: String?
        let isVisible: Bool?
        let sortOrder: Int?
    }

    struct Widgets: Codable {
        let pending_pickup: Int?
        let pre_transit: Int?
        let in_transit: Int?
        let delivered: Int?
        let recovery: Int?
        let rc_expired: Int?
        let at_delivery: Int?
        let available: Int?
        let totalCount: Int?
    }
}
