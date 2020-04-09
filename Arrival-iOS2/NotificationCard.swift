//
//  NotificationCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/26/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct NotificationCard: View {
    @EnvironmentObject private var appData: AppData

    var type = "tripDetail"
    
    var body: some View {
        
        HStack {
         
            VStack(alignment: .leading) {
                if (self.type == "review") {
                    Text("Enjoy using Arrival?")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("please consider giving us a review!")
                        .font(.caption)
                } else if (self.type == "tripDetail"){
                    Text("Learn more about your trip")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("tap on a trip card to see transfers and timing")
                        .font(.caption)
                }
            }
            
            Spacer()
            HStack(alignment: .top) {
                Button(action: {
                     print("btn clicked")
                    if (self.type == "review") {
                        self.appData.hideReviewCard()
                    } else  if (self.type == "tripDetail") {
                        self.appData.hideDetailCard()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(Color.gray)
                }
                
            }
        }.padding().cornerRadius(10).background(Color.background).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard().environmentObject(AppData())
    }
}
