//
//  StationChooserView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationChooserView: View {
    
       var body: some View {
        VStack(alignment: .leading) {
         
            TextField("Search for a Station", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            
            Spacer()
        }.padding()
    }
}

struct StationChooserView_Previews: PreviewProvider {
    static var previews: some View {
        StationChooserView()
    }
}
