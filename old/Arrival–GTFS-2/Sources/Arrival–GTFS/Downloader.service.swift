//
//  Downloader.service.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/12/25.
//

import Foundation
internal import Zip

/*
public class GTFSFileManager {
    public init() {
        self.initializeURLS()
    }
  
    var dbLocation: URL! = nil
    var downloadZipLocation: URL = FileManager.default.temporaryDirectory.appendingPathComponent("google_transit.zip")
    var unpackedDataLocation: URL! = nil
   
    
    func initializeURLS() {
        guard let destiation = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
           return
        }
        
        self.dbLocation = destiation.appending(path: "Arrival/db")
        self.unpackedDataLocation = destiation.appending(path: "Arrival/gtfs/")
    }
    
    let gtfsURL = URL(string: "https://www.bart.gov/dev/schedules/google_transit.zip")!
    
    func downloadGTFS() async throws {
        
        let (tempURL, _, error) = await withCheckedContinuation { continuation in
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
        if FileManager.default.fileExists(atPath: downloadZipLocation.path) {
                try FileManager.default.removeItem(at: downloadZipLocation)
            }

            // Copy the tempURL to file
            try FileManager.default.copyItem(
                at: tempURL,
                to: downloadZipLocation
            )

        
        

     
    }
    func unzipGTFS() async throws {
       
        try Zip.unzipFile(self.downloadZipLocation, destination: self.unpackedDataLocation, overwrite: true, password: nil, progress: { (progress) -> () in
               // print(progress)
            }) // Unzip
        

        
    }
    func saveDB() async throws {
        guard let dbLocation else {
            throw URLError(.badServerResponse)
        }
         let encodedData = try JSONEncoder().encode(GTFSDB.shared)
          
       
        try encodedData.write(to: dbLocation)
                print(dbLocation)
           
        }
    func loadDB() async throws {
        guard let dbLocation else {
            throw URLError(.badServerResponse)
        }
        
        let data = try Data(contentsOf: dbLocation)
               let decoder = JSONDecoder()
               let jsonData = try decoder.decode(GTFSDB.self, from: data)
        GTFSDB.shared.importData(jsonData)
        
    }
        
    
}
*/
