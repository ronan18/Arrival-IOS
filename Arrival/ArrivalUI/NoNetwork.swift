//
//  NoNetwork.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 9/27/21.
//

import SwiftUI

public struct NoNetwork: View {
    public init (retry: @escaping ()->()) {
        
    }
    public var body: some View {
        GeometryReader {geo in
            VStack {
                Spacer().frame(height: geo.size.height / 6)
                Image(systemName: "wifi.exclamationmark").resizable().aspectRatio(contentMode: .fit).foregroundColor(.red).frame(height: geo.size.width * 0.4).padding(.vertical)
                Text("Error Connecting To Network").font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                Text("Arrival needs internet acess in order to fetch BART information.").multilineTextAlignment(.center).font(.subheadline)
                Spacer()
                Button(action: {}) {
                    HStack {
                        Spacer()
                
                        Text("Retry")
                        Spacer()
                    }
                   
                }.buttonStyle(.borderedProminent).controlSize(.large)
            }.padding().multilineTextAlignment(.center)
        }
        
    }
}

struct NoNetwork_Previews: PreviewProvider {
    static var previews: some View {
        NoNetwork(retry: {})
    }
}
