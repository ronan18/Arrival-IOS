//
//  Downloader.service.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/12/25.
//

import Foundation

public class GTFSDownloader {
    public init() {}
    static let shared = GTFSDownloader()
    let gtfsURL = URL(string: "https://www.bart.gov/dev/schedules/google_transit.zip")!
    
    func downloadGTFS() async throws {
        let file = FileManager.default.temporaryDirectory.appendingPathComponent("google_transit.zip")
       let (tempURL, response, error) = await withCheckedContinuation { continuation in
            let task = URLSession.shared.downloadTask(with: gtfsURL) {
                (tempURL, response, error) in
                
                continuation.resume(returning: (tempURL, response, error))
            }
            
            // Start the download
            task.resume()
        }
        // Early exit on error
        guard let tempURL = tempURL else {
           throw error ?? URLError(.badServerResponse)
         
        }

    
            // Remove any existing document at file
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }

            // Copy the tempURL to file
            try FileManager.default.copyItem(
                at: tempURL,
                to: file
            )
print(file)
          return
        

     
    }
}
