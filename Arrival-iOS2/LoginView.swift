//
//  LoginView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/22/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var onboard = 0
    @State var passphrase = ""
    @State var newPass = ""
    @EnvironmentObject private var appData: AppData
    var body: some View {
         GeometryReader { geometry in
        VStack(alignment: .center) {
            
            if (self.appData.authLoading) {
                LoadingView()
            } else {
                if (self.onboard == 0) {
                    Spacer()
                    GeometryReader { geo in
                        Image("map")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                    }
                    .frame(height: 250)
                    Text("Welcome to Arrival")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    Text("the faster, smarter way to coordinate BART schedules")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        self.onboard = 4
                    }) {
                        HStack {
                            Spacer()
                            Text("CONTINUE")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    
                    
                } else if (self.onboard == 4) {
                    HStack {
                        Button(action: {
                            self.onboard = 0
                        }) {
                            Text("Back")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    Spacer()
                    GeometryReader { geo in
                        Image("dataSync")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                    }
                    .frame(height: 250)
                    Text("Low Data Usage")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("Arrival harnesses modern technologies in order to receive schedules and make predictions without using tons of cellular data.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    Button(action: {
                        self.onboard = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("CONTINUE")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    
                    
                } else if (self.onboard == 1) {
                    HStack {
                        Button(action: {
                            self.onboard = 4
                        }) {
                            Text("Back")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    Spacer()
                    GeometryReader { geo in
                        Image("secure")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width)
                    }
                    .frame(height: 250)
                    Text("Anonymous")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("Because Arrival generates some pretty personal information about you, your daily commute, we have created an anonymous authentication system that still allows for cross device syncing.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        self.onboard = 3
                    }) {
                        HStack {
                            Spacer()
                            Text("CREATE NEW ACCOUNT")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    Spacer()
                        .frame(height: 10.0)
                    Button(action: {
                        self.onboard = 2
                    }) {
                        HStack {
                            Spacer()
                            Text("I HAVE AN ACCOUNT")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }.background(Color.white).cornerRadius(10.0).foregroundColor(.black).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    
                } else if (self.onboard == 2) {
                    HStack {
                        Button(action: {
                            self.onboard = 1
                        }) {
                            Text("Back")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    VStack {
                        TextField("Enter Your Passphrase", text: self.$passphrase).padding()
                        Rectangle().fill(Color("arrivalBlue")).frame(height: 5)
                        
                    }
                    
                    
                    Text("enter your passphrase")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        if (!self.passphrase.isEmpty) {
                            self.appData.loginFromWeb(passphrase: self.passphrase)
                        }
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("LOGIN")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(CGFloat(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    
                } else if (self.onboard == 3) {
                    HStack {
                        Button(action: {
                            self.onboard = 1
                        }) {
                            Text("Back")
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    Text(self.newPass)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.arrivalBlue)
                    
                    Spacer()
                        .frame(height: 14.0)
                    Text("Arrival’s syncing is a little different. We generate your passphrase randomly. This allows us to ensure that none of the data we collect can be directly linked to you. In order to transfer or retrieve your data just enter this passphrase when you first start the app. You might want to write this down. If you forget it all of your data will be lost")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        
                        print("trying to create new account", self.newPass)
                        self.appData.createNewAccount(passphrase: self.newPass)
                        
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("CONFIRM")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Spacer()
                        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(CGFloat(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    
                }
                
            }
           
             
        }
        .padding().onAppear(perform: {
            func randomString(length: Int) -> String {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return String((0..<length).map{ _ in letters.randomElement()! })
            }
            self.newPass = randomString(length: 6)
        })
            
    }
       
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
             LoginView().environmentObject(AppData()).environment(\.colorScheme, .light)
        LoginView().environmentObject(AppData()).environment(\.colorScheme, .dark)
        }
    }
}
