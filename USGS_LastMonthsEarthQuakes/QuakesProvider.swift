//
//  QuakesProvider.swift
//  20220707a_usgs
//
//  Created by Peter Harding on 7/7/2022.
//

import Foundation
import OSLog
import SwiftUI


class QuakesProvider: ObservableObject {
    
    @Published var processedMessage = ""
    @Published var isProcessing = false

    /// Geological data provided by the U.S. Geological Survey (USGS). See ACKNOWLEDGMENTS.txt for additional details.
    let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson")!
    
    let logger = Logger(subsystem: "com.example.apple-samplecode.Earthquakes", category: "persistence")
    
    /// A shared quakes provider for use within the main app bundle.
    static let shared = QuakesProvider()

    /// Fetches the earthquake feed from the remote server, and imports it into Core Data.
    func fetchQuakes() async throws {
        
        isProcessing = true
        
        let session = URLSession.shared
        
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            logger.debug("Failed to received valid response and/or data.")
            throw QuakeError.missingData
        }
        
        print("Completed call to API...")
        print("\(data.description)")

        var noRecords = 0
        
        do {
            // Decode the GeoJSON into a data model.
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let geoData = try jsonDecoder.decode(GeoData.self, from: data)

            logger.debug("Received \(geoData.features.count) records.")
            print("GeoData |\(String(describing: geoData.features.count))|")
            
            // Watch it being decoded
            geoData.features.forEach { feature in
                print("\(feature.id)  \(feature.properties.magnitude) \(feature.properties.place) \(feature.properties.code) \(feature.properties.time) \(feature.geometry.coordinates)")
                noRecords += 1
            }
            
            processedMessage = "Received \(noRecords) earthquake records."
            
            // Do somethiong with the GeoJSON into Core Data.
            logger.debug("Finished processing data - \(self.processedMessage).")
        } catch {
            print("Decode error")
            throw QuakeError.wrongDataFormat(error: error)
        }
        
        isProcessing = false
    }

}
