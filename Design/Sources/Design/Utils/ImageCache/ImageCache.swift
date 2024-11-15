import UIKit

/// ```swift
/// // HOW TO USE IT
/// func downloadImages() {
///     let url = URL(string: "https://example.com/image.jpg")!
///     ImageCache.shared.loadImage(url: url) { image in
///         // Do something with the image
///     }
/// }
/// ```
class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache: NSCache<NSString, UIImage>
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: key)
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
