//
//  HeaderAlert.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct HeaderAlert: View {
    @State private var alertOpen = false
    let message: String
    let link: URL?
    public init(message: String, link: URL? = nil) {
        self.message = message
        self.link = link
    }
    public  var body: some View {
        HStack {
            DisclosureGroup( isExpanded: self.$alertOpen, content: {
                HeaderAlertContent(message: self.message, link: self.link)
            }, label: {HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color("LightText"))
                Text("Alert").font(.headline)
                if (!self.alertOpen) {
                Text(message).lineLimit(1).font(.subheadline)
                }
            }}).foregroundColor(Color("LightText")).accentColor(Color("OppositeTextColor")).padding(.horizontal).padding(.vertical, 10).background(Color("Gray"))
        }
    }
}

struct HeaderAlert_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Text("test")
                }
               
            }.frame(height:20).background(.black)
        HeaderAlert(message: "Due to COVID-19 BART is operating under a modified schedule. Face coverings are required.", link: nil)
            Spacer()
        }
    }
}

struct HeaderAlertContent: View {
    let message: String
    var link: URL? = nil
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(message)
              
                    Text("[learn more](https://www.bart.gov/schedules/advisories)")
                        .fontWeight(.bold).foregroundColor(.accentColor).accentColor(.accentColor).padding(.top, 1)
            }.padding(.vertical, 10)
            Spacer()
        }
    }
}
