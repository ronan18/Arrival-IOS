//
//  TripComponentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TripComponentView: View {
    var body: some View {
  
            VStack {
                HStack {
                Rectangle().frame(width: 8.0).foregroundColor(.yellow)
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Station Name")
                                .fontWeight(.semibold)
                            HStack(spacing: 0) {
                            Image(systemName: "arrow.right.circle.fill").font(.subheadline)
                                Spacer()
                                    .frame(width: 3.0)
                              Text("Direction").font(.subheadline)
                                
                            }
                          
                    
                           
                        }
                        Spacer()
                        Text("5:55pm")
                            .font(.subheadline)
                    }
                    HStack {
                        Text("11 stops untill...")
                                                      .font(.caption).padding([.top, .bottom, .trailing])
                         Spacer()
                        Text("55min")
                        .font(.caption)
                       
                    }
                    HStack {
                                          VStack(alignment: .leading, spacing: 0) {
                                              Text("Destination Name")  .fontWeight(.semibold)
                                           
                                            
                                      
                                             
                                          }
                                          Spacer()
                                          Text("5:55pm")
                                              .font(.subheadline)
                                      }
                }.padding([.top, .bottom, .trailing]).padding(.leading, 5.0)
                }
            }.cornerRadius(10).background(Color.background).overlay(
                RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
            ).cornerRadius(10.0)
           
        
    }
}

struct TripComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TripComponentView()
    }
}
