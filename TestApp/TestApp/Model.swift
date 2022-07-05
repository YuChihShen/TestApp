//
//  Model.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/5.
//

import Foundation

// MARK: - MaskCountInfo
struct MaskCountInfo: Codable {
    let features: [Feature]
}
// MARK: - Feature
struct Feature: Codable {
//    let type: String
    let properties: Properties
//    let geometry: Geometry
}

// MARK: - Geometry
//struct Geometry: Codable {
//    let type: String
//    let coordinates: [Double]
//}

// MARK: - Properties
struct Properties: Codable {
    let id, name, phone, address: String
    let maskAdult, maskChild: Int
    let updated, available, note, customNote: String
    let website, county, town, cunli: String
    let servicePeriods: String

    enum CodingKeys: String, CodingKey {
        case id, name, phone, address
        case maskAdult = "mask_adult"
        case maskChild = "mask_child"
        case updated, available, note
        case customNote = "custom_note"
        case website, county, town, cunli
        case servicePeriods = "service_periods"
    }
}
