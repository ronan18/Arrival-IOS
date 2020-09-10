//
//  SkeletonTrainCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SkeletonTrainCard: View {
      private let latterAlignment: HorizontalAlignment = .leading
    var body: some View {
         HStack(){
                 
                  HStack(alignment: .bottom) {
                      VStack (alignment: .leading) {
                          Text("direction")
                              .font(.caption).background(Color("skeleton--light"))
                        Spacer().frame(height:2)
                          Text("Rockridge")
                              .font(.headline).background(Color("skeleton--light"))
                      }
                      Spacer()
                  
                          VStack (alignment: latterAlignment) {
                              Text("cars")
                                  .font(.caption).background(Color("skeleton--light"))
                             Spacer().frame(height:2)
                              Text(String(10))
                                  .font(.headline).background(Color("skeleton--light"))
                          }
                      
                      VStack (alignment: latterAlignment) {
                          Text("departs")
                              .font(.caption).background(Color("skeleton--light"))
                         Spacer().frame(height:2)
                          HStack(alignment: .bottom,spacing: 0) {
                              Text("100")
                                  .font(.headline).background(Color("skeleton--light"))
                            
                              
                              
                          }
                          
                      }
                 
                  }.padding().foregroundColor(Color("skeleton--light"))
              }.frame(height: 60.0).cornerRadius(10).background(Color("cardBackground")).overlay(
                  RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
              ).cornerRadius(10.0)
    }
}

struct SkeletonTrainCard_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonTrainCard()
    }
}
