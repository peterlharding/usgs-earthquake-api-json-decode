//
//  GeoJSON.swift
//  20220707a_usgs
//
//  Created by Peter Harding on 7/7/2022.
//

import Foundation
import OSLog


private struct DummyCodable: Codable {}

struct Properties: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
        case updated
        case code
    }
    
    let magnitude: Double
    let place: String
    let time: Int
    let updated: Int
    let code: String
    
    func toDate(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let formattedDate = dateFormatter.string(from: date)
        print(formattedDate)
        return formattedDate
    }
    
    // The keys must have the same name as the attributes of the Quake entity.
    var dictionaryValue: [String: Any] {
        [
            "magnitude": magnitude,
            "place": place,
            "time": toDate(time: TimeInterval(time) / 1000),
            "code": code
        ]
    }
}

struct Geometry: Decodable {
    let type: String
    let coordinates: [Double]
}

struct Feature: Decodable {
    let type: String
    let properties: Properties
    let geometry: Geometry
    let id: String
}

struct Metadata: Decodable {
    let generated: Double
    let url: String
    let title: String
    let status: Int
    let api: String
    let count: Int
}

struct GeoData: Decodable {
    let type: String
    let metadata: Metadata
    let features: [Feature]
}

// ---------------------------------------------------------------------------
// Note:  to retrieve this data you need to use this code
//
//  let jsonDecoder = JSONDecoder()
//  jsonDecoder.dateDecodingStrategy = .secondsSince1970
//  let geoData = try jsonDecoder.decode(GeoData.self, from: data)
//
// ---------------------------------------------------------------------------

