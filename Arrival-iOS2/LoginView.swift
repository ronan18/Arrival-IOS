//
//  LoginView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/22/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var onboard = true
    @State var passphrase = ""
    @EnvironmentObject private var appData: AppData
    var body: some View {
        VStack(alignment: .center) {
            if (onboard) {
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
                Text("the faster, smarter way to coordinate BART schedules")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    self.onboard = false
                }) {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        Spacer()
                    }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                
                
            } else {
                Spacer()
                VStack {
                    TextField("Enter Your Passphrase", text: $passphrase).padding()
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
                        Text("Login")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        Spacer()
                    }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(CGFloat(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                
            }
            
            
            
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppData())
    }
}
