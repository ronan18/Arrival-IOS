//
//  ContentView.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import CoreLocation
let manager = CLLocationManager()


struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var modalDisplayed = false
    
    let baseAPI = "https://api.arrival.city"
    let stationAPI = "https://api.arrival.city/api/v2/stationlist"
    
    init() {
        
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        
        NavigationView {
            List(userData.trains) { Train in
                
                HStack {
                    Rectangle()
                        .frame(width: CGFloat(10.0))
                        .foregroundColor(colorToColor(color: Train.color) as! Color)
                        .cornerRadius(CGFloat(10.0))
                    HStack {
                        
                        //  let color: Color = colorToColor(color: Train.color)
                        
                        VStack(alignment: .leading) {
                            Text("direction")
                                .font(.caption)
                            Text(Train.direction).font(.headline)
                        }
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("cars")
                                .font(.caption)
                            
                            Text(String(Train.cars)).font(.headline)
                            
                            
                        }
                        VStack(alignment: .leading) {
                            Text("departs")
                                .font(.caption)
                            HStack {
                                Text(String(Train.time)).font(.headline)
                                Spacer()
                                    .frame(width: CGFloat(2.0))
                                Text(Train.unit).font(.subheadline).fontWeight(.regular)
                                
                            }
                            
                        }
                        
                    }.padding([.top, .leading, .bottom], CGFloat(7.0))
                }.padding(.vertical, CGFloat(8.0)).padding(.horizontal, CGFloat(16.0)).background(Color.lightDarkBG).overlay(
                    RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: CGFloat(1.0))
                ).cornerRadius(10.0)
            }.navigationBarItems(leading:
                HStack(alignment: .center) {
                    Button(action: {self.modalDisplayed = true}) {
                        Text(userData.closestStation.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.whiteDark)
                    }.sheet(isPresented: $modalDisplayed) {
                        StationView(onDismiss: {
                            self.modalDisplayed = false
                            }).environmentObject(UserData())
                    }
                    
                }
                
                
            )
            
        }
        
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
