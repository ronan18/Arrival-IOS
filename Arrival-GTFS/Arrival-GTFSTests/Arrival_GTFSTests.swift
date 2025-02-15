//
//  Arrival_GTFSTests.swift
//  Arrival-GTFSTests
//
//  Created by Ronan Furuta on 2/12/25.
//

import Testing
@testable import Arrival_GTFS

struct Arrival_GTFSTests {

    @Test func downloadGTFS() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let downloadStart = Date.now
      let url = try await GTFSDownloader.shared.downloadGTFS()
        print(url)
       let zipURL = try await GTFSDownloader.shared.unzipGTFS(file: url)
        print(zipURL)
        
        let start = Date.now
        let GTFS = try await GTFS(path: zipURL.path)
        print("Initialized GTFS in \(Date.now.timeIntervalSince(start))")
        #expect(GTFS.agencies.count > 0)
        #expect(GTFS.stops.count >= 50)
        let gtfsDBINITStart = Date.now
       try await GTFSDB.shared.ingest(gtfs: GTFS)
        print("Initialized GTFSDB in \(Date.now.timeIntervalSince(gtfsDBINITStart))")
        print("Total run  in \(Date.now.timeIntervalSince(downloadStart))")
    }

}
