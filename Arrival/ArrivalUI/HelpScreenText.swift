//
//  HelpScreen.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/23/21.
//

import SwiftUI
import ArrivalCore

public struct HelpScreenText: View {
    var config: helpScreenData
    public init(_ config: helpScreenData) {
        self.config = config
    }
    public var body: some View {
        
        VStack(alignment:.leading, spacing: 0) {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading) {
                    ForEach(config.content) {row in
                        if (row.type == .heading) {
                            Text(row.formattedContent).font(.title2).fontWeight(.bold)
                        } else if (row.type == .text) {
                            Text(row.formattedContent)
                        } else if (row.type == .image) {
                            
                            AsyncImage(url: URL(string: row.content)) {image in
                                image.resizable().aspectRatio( contentMode: .fill).clipped()
                            } placeholder: {
                                VStack {
                                    ProgressView().tint(.white)
                                }.frame(width: geo.size.width, height: geo.size.width/1.3).background(.gray)
                            }.frame(width: geo.size.width, height: geo.size.width/1.3).padding(.vertical, 2)
                            
                            
                        } else if (row.type == .devider) {
                            Divider()
                        } else if (row.type == .spacer) {
                            Spacer().frame(height: 20)
                        }
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                    }
                    }
                }
            }
        }.padding(.horizontal).navigationTitle(config.name).foregroundColor(Color("TextColor"))
        
    }
}

struct HelpScreenText_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HelpScreenText(defaultHelpContent.featured)
        }
    }
}
