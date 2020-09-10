//
//  SkeletonLoading.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SkeletonLoading: View {
    var spacing:CGFloat = 5
    
    var body: some View {
        ScrollView {
         Spacer().frame(height: 5)
        ForEach(0..<5) { trip in
            Button(action: {}) {
            SkeletonTrainCard().padding([.horizontal])
                       
                       
                   }
        }.disabled(true).foregroundColor(Color("Text"))
        }.onAppear() {
            if #available(iOS 14.0, *) {
                      // modern code
                      let spacing = 100
                  } else {
                      // Fallback on earlier versions
                      let spacing = 60
                  }
        }
    }
}

struct SkeletonLoading_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonLoading().environment(\.colorScheme, .dark)
    }
}
