import Testing
import Foundation
@testable import Arrival_GTFS

struct Arrival_GTFSTests {

   /* @Test func downloadGTFS() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        GTFSFileManager.shared.initializeURLS()
        let downloadStart = Date.now
   try await GTFSFileManager.shared.downloadGTFS()
    
      try await GTFSFileManager.shared.unzipGTFS()
       
        
        let start = Date.now
        let GTFS = try await GTFS(path:  GTFSFileManager.shared.unpackedDataLocation!.path)
        print("Initialized GTFS in \(Date.now.timeIntervalSince(start))")
        #expect(GTFS.agencies.count > 0)
        #expect(GTFS.stops.count >= 50)
        let gtfsDBINITStart = Date.now
       try await GTFSDB.shared.ingest(gtfs: GTFS)
        print("Initialized GTFSDB in \(Date.now.timeIntervalSince(gtfsDBINITStart))")
        print("Initialized DATA in \(Date.now.timeIntervalSince(start))")
        print("Total run  in \(Date.now.timeIntervalSince(downloadStart))")
    }
    
    @Test func injestGTFS() async throws {
       
        GTFSFileManager.shared.initializeURLS()
        let finalDest = GTFSFileManager.shared.unpackedDataLocation!
        let start = Date.now
        let GTFS = try await GTFS(path: finalDest.path)
        print("Initialized GTFS in \(Date.now.timeIntervalSince(start))")
        #expect(GTFS.agencies.count > 0)
        #expect(GTFS.stops.count >= 50)
        let gtfsDBINITStart = Date.now
       try await GTFSDB.shared.ingest(gtfs: GTFS)
        print("Initialized GTFSDB in \(Date.now.timeIntervalSince(gtfsDBINITStart))")
        print("Initialized DATA in \(Date.now.timeIntervalSince(start))")
        
        let incodeState = Date.now
        try await GTFSFileManager.shared.saveDB()
        print("saved DATA in \(Date.now.timeIntervalSince(incodeState))")
        
        let decodeStart = Date.now
        
        _ = try await GTFSFileManager.shared.loadDB()
        print("read DATA in \(Date.now.timeIntervalSince(decodeStart))")

        
    }*/
    
    

}
