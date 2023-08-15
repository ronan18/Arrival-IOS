//
//  RTManager.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import ArrivalGTFS

public class RTManager {
    var handle: (TransitRealtime_FeedMessage) async ->()
    private var tripUpdateURL = URL(string: "https://api.bart.gov/gtfsrt/tripupdate.aspx")!
    private var alertsURL = URL(string: "https://api.bart.gov/gtfsrt/alerts.aspx")!
    
    public init () {
        self.handle = {i in}
    }
    func setHandler(handle: @escaping (TransitRealtime_FeedMessage) async ->()) {
        self.handle = handle
    }
    private func downloadData() async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: tripUpdateURL)
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
          
            throw ApiError.not200
            }

            return data
     
    }
    public func update() async {
        guard let data = try? await self.downloadData() else {
            return
        }
        guard let feedMessage = try? TransitRealtime_FeedMessage(serializedData: data) else {
            return
        }
        await self.handle(feedMessage)
       
    }
    public func getAlerts() async throws -> [TransitRealtime_Alert] {
        let (data, response) = try await URLSession.shared.data(from: alertsURL)
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
          
            throw ApiError.not200
            }

        let feed = try TransitRealtime_FeedMessage(serializedData: data)
        return feed.entity.compactMap({entity in
            guard entity.hasAlert else {
                return nil
            }
            return entity.alert
        })
    }
    
}
