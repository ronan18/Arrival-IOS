//
//  AuthorizeLocationView.swift
//  ArrivalWatch WatchKit Extension
//
//  Created by Ronan Furuta on 9/29/21.
//

import SwiftUI

struct AuthorizeLocationView: View {
    @ObservedObject var appState: WatchAppState
    var body: some View {
        Text("Authorize location")
    }
}

struct AuthorizeLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizeLocationView(appState: WatchAppState())
    }
}
