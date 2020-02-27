//
//  LoginView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/22/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseCrashlytics
struct LoginView: View {
    @State var onboard = 0
    @State var passphrase = ""
    @State var newPass = ""
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                if (self.appData.authLoading || !self.appData.onboardingLoaded) {
                    LoadingView()
                } else {
                    if (self.onboard == 0) {
                        Spacer()
                        GeometryReader { geo in
                            Image("map")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width - 10)
                        }
                        .frame(height: 250)
                        Text(self.appData.onboardingMessages["onboarding1Heading"].stringValue)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                        Text(self.appData.onboardingMessages["onboarding1Tagline"].stringValue)
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
                                .frame(width: geo.size.width - 10)
                        }
                        .frame(height: 250)
                        Text(self.appData.onboardingMessages["onboarding2Heading"].stringValue)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                        Text(self.appData.onboardingMessages["onboarding2Tagline"].stringValue)
                            .font(.subheadline)
                            .multilineTextAlignment(.center).padding()
                        Spacer()
                        
                        Button(action: {
                            self.onboard = 5
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
                                self.onboard = 5
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
                                .frame(width: geo.size.width - 10)
                        }
                        .frame(height: 250)
                        Text(self.appData.onboardingMessages["onboarding3Heading"].stringValue)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        Text(self.appData.onboardingMessages["onboarding3Tagline"].stringValue)
                            .font(.subheadline)
                            .multilineTextAlignment(.center).padding()
                        Spacer()
                        TermsOfSeriviceView()
                        Button(action: {
                          
                            print("trying to create new account", self.newPass)
                            Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                                AnalyticsParameterMethod: "authScreen"
                            ])
                            self.appData.createNewAccount(passphrase: self.newPass)
                            
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("START NOW")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                Spacer()
                            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(CGFloat(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                       
                        
                    } else if (self.onboard == 5) {
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
                            Image("location")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width - 10)
                        }
                        .frame(height: 250)
                        Text(self.appData.onboardingMessages["onboarding4Heading"].stringValue)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                        Text(self.appData.onboardingMessages["onboarding4Tagline"].stringValue)
                            .font(.subheadline)
                            .multilineTextAlignment(.center).padding()
                        Spacer()
                        
                        Button(action: {
                            self.appData.requestLocation()
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
                        
                        
                    }
                    
                }
                
                
            }
            .padding().onAppear(perform: {
                // Analytics.setScreenName("login", screenClass: "login")
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
