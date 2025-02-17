import UIKit

public enum ImageSource {
    case url(URL)
    case image(UIImage)
    case none // Handle nil cases
}

//public class ImageLoader: ObservableObject {
//    public enum State {
//        case loading
//        case failure
//        case success(UIImage)
//    }
//
//    @Published private(set) public var state = State.loading
//
//    private let imageSource: ImageSource
//
//    public init(imageSource: ImageSource) {
//        self.imageSource = imageSource
//    }
//
//    public func load() {
//        switch imageSource {
//        case .url(let url):
//            ImageCache.shared.loadImage(url: url) { image in
//                DispatchQueue.main.async {
//                    if let image = image {
//                        self.state = .success(image)
//                    } else {
//                        self.state = .failure
//                    }
//                }
//            }
//        case .image(let image):
//            DispatchQueue.main.async {
//                self.state = .success(image)
//            }
//        case .none:
//            DispatchQueue.main.async {
//                self.state = .failure
//            }
//        }
//    }
//
//}
@Observable
public class ImageLoader {
    public enum State {
        case loading
        case failure
        case success(UIImage)
    }
    public private(set) var state: State = .loading

    private let imageSource: ImageSource

    public init(imageSource: ImageSource) {
        self.imageSource = imageSource
    }

    public func load() {
        switch imageSource {
        case .url(let url):
            ImageCache.shared.loadImage(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let image = image {
                        self.state = .success(image)
                    } else {
                        self.state = .failure
                    }
                }
            }
        case .image(let image):
            self.state = .success(image)
        case .none:
            self.state = .failure
        }
    }

}
