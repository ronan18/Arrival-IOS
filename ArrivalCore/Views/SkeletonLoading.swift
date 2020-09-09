//
//  SkeletonLoading.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SkeletonLoading: View {
    var body: some View {
        ScrollView {
         Spacer().frame(height: 5)
        ForEach(0..<5) { trip in
                      
            SkeletonTrainCard().padding([.horizontal]).padding(.vertical, 5)
                       
                       
                   }
        }
    }
}

struct SkeletonLoading_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonLoading().environment(\.colorScheme, .dark)
    }
}
