//
//  RemoteImage.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

public struct RemoteImage: View {
    let url: URL
    let imageLoader = ImageLoader()
    @State var image: UIImage? = nil
    public init(url: URL) {
        self.url = url
    }
    public  var body: some View {
        Group {
            makeContent()
        }
        .onReceive(imageLoader.objectWillChange, perform: { image in
            print("IMAGE LOADER LOADED IMAAGE INTO VIEW")
            self.image = image
        })
        .onAppear(perform: {
            self.imageLoader.load(url: self.url)
        })
        .onDisappear(perform: {
            self.imageLoader.cancel()
        })
    }

    private func makeContent() -> some View {
        if let image = image {
            return AnyView(
                
            Image(uiImage: image)
                  .resizable().frame(width: 50, height: 50).aspectRatio(contentMode: .fill).cornerRadius(10)
               
               
            )
        } else {
            return AnyView(
                VStack{
                    Text("")
                }.frame(width: 50, height: 50).background(Color("skeleton--light")).foregroundColor(Color("skeleton--light")).cornerRadius(10)
            )
        }
    }
}
