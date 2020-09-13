//
//  TrainsViewNoScroll.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainsViewNoScroll: View {
    var trains: [Train]

 
    var body: some View {

            
          
                        ForEach(trains) { train in
                            TrainCard(train: train)
                       
        
                
 
            
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct TrainsViewNoScroll_Previews: PreviewProvider {
    static var previews: some View {
        TrainsViewNoScroll(trains: [])
    }
}
