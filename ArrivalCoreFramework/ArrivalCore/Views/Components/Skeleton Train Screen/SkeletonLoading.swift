//
//  SkeletonLoading.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public struct SkeletonLoading: View {
    @State var spacing:CGFloat = 5
    public init() {
        
    }
    public var body: some View {
        ScrollView {
         Spacer().frame(height: 5)
        ForEach(0..<5) { trip in
            Button(action: {}) {
                SkeletonTrainCard().padding([.horizontal]).padding(.vertical, spacing)
                       
                       
                   }
        }.disabled(true).foregroundColor(Color("Text"))
        }.onAppear() {
            if #available(iOS 14.0, *) {
                      // modern code
                self.spacing = 0
                  } else {
                      // Fallback on earlier versions
                    self.spacing = 5
                  }
        }
    }
}

struct SkeletonLoading_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonLoading().environment(\.colorScheme, .dark)
    }
}
