//
//  ShareSheet.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/9/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
public struct ShareSheet: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIActivityViewController

    public  var sharing: [Any]
    

    public  func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        UIActivityViewController(activityItems: sharing, applicationActivities: nil)
    }

    public   func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {

    }
}
