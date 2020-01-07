//
//  Login.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Login: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Arrival")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Spacer()
                .frame(height: 30.0)
            Text("Welcome to the Arrival IOS BETA. Currently we are developing a fully featured version of Arrival for IOS. This version is NOT compleete. However, by using it and reporting bugs you will help the creation of the fully featured Arrival")
                .font(.body)
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 30.0)
            Text("Please Enter Your Passphrase")
                .font(.headline)
            Text("currently account creation is not supported")
                .font(.subheadline)
            HStack() {
                Text("Passphrase").bold()
                Divider()
                TextField("Passphrase", text: $userData.passphrase)
            }.frame(height: 10.0)
            
            Button(action: {
                // What to perform
                print("logging in...")
                let headers: HTTPHeaders = [
                    "Authorization": self.userData.passphrase,
                    "Accept": "application/json"
                ]
                Alamofire.request("https://api.arrival.city/api/v2/login", headers: headers).responseJSON {
                    response in print(response.value)
                    let jsonResponse = JSON(response.value)
                    if jsonResponse["user"].stringValue == "true" {
                        self.userData.authorized = true
                        self.userData.beginHome()
                        print("user authorized")
                       
                    } else {
                        print("user not authorized")
                    }
                }
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .cornerRadius(10)
                
            }
            Spacer()
        }.padding().frame(width: nil).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).edgesIgnoringSafeArea(.all)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(UserData())
    }
}
