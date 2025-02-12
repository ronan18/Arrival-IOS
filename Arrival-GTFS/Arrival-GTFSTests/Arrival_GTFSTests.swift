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
        
       try await GTFSDownloader.shared.downloadGTFS()
    }

}
