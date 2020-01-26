//
//  HomeView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import UIKit
struct HomeView: View {
    @State var fromModalDisplayed = false
    init() {
        // 1.
        UINavigationBar.appearance().backgroundColor = UIColor(named: "arrivalBlue")
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button  (action: {
                        
                        self.fromModalDisplayed = true
                    }) {
                        VStack(alignment: .leading) {
                            Text("from").font(.caption)
                            Text("Station").font(.headline)
                        }
                    }.sheet(isPresented: $fromModalDisplayed) {
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text("From Station")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: {
                                    self.fromModalDisplayed = false
                                }) {
                                    Text("Dismiss")
                                }
                            }
                            StationChooserView()
                        }.padding()
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("to").font(.caption)
                        Text("Station").font(.headline)
                    }
                }.padding().foregroundColor(.white).background(Color.blackBG)
                TrainView()
            }.navigationBarTitle("Arrival")
        }.padding(.top, 43.0).edgesIgnoringSafeArea(.top).onAppear(){
            print("home Appeared")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            HomeView().environment(\.colorScheme, .light)
            HomeView().environment(\.colorScheme, .dark)
        }
    }
}
