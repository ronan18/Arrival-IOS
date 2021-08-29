//
//  HeaderAlert.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct HeaderAlert: View {
    @State private var alertOpen = false
    public init() {}
    public  var body: some View {
        HStack {
            DisclosureGroup( isExpanded: self.$alertOpen, content: {
                HeaderAlertContent()
            }, label: {HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color("LightText"))
                Text("Alert").font(.headline)
                if (!self.alertOpen) {
                Text("Due to COVID-19 BART is operating under a modified schedule. Face coverings are required.").lineLimit(1).font(.subheadline)
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
        HeaderAlert()
            Spacer()
        }
    }
}

struct HeaderAlertContent: View {
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Due to COVID-19 BART is operating under a modified schedule. Face coverings are required.")
                Button(action: {}) {
                    Text("learn more")
                        .fontWeight(.bold)
                }.foregroundColor(.accentColor).accentColor(.accentColor).padding(.top, 1)
            }.padding(.vertical, 10)
            Spacer()
        }
    }
}
