//
//  ImageLoader.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import Combine
import UIKit

public class ImageLoader: ObservableObject {
    private var cancellable: AnyCancellable?
    public  let objectWillChange = PassthroughSubject<UIImage?, Never>()

    public   func load(url: URL) {
        print("IMAGE LOADER LOADING")
        self.cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .map({ $0.data })
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .map({ UIImage(data: $0) })
            .replaceError(with: nil)
            .sink(receiveValue: { image in
                print("IMAGE LOADER LOADED")
                self.objectWillChange.send(image)
                print("IMAGE LOADER LOADED SENT")
            })
    }

    public  func cancel() {
        print("IMAGE LOADER CANCLED")
        cancellable?.cancel()
    }
}
