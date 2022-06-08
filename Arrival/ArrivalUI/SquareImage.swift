//
//  SquareImage.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/16/21.
//

import SwiftUI

public struct SquareImage: View {
    var width: CGFloat = 70
    var image: URL
    public init(image: String) {
        self.image = URL(string: image)!
        
    }
   public var body: some View {
       AsyncImage(url: image) {image in
           image.resizable().aspectRatio( contentMode: .fill).clipped()
       } placeholder: {
           VStack {
               ProgressView().tint(.white)
           }.frame(width: width, height: width).background(.gray)
       }.frame(width: width, height: width).cornerRadius(10)
    }
}

struct SquareImage_Previews: PreviewProvider {
    static var previews: some View {
        SquareImage(image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80")
    }
}
