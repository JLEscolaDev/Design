#if os(macOS)
import AppKit

/// ```swift
/// // HOW TO USE IT
/// func downloadImages() {
///     let url = URL(string: "https://example.com/image.jpg")!
///     ImageCache.shared.loadImage(url: url) { image in
///         // Do something with the image (NSImage)
///     }
/// }
/// ```
class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache: NSCache<NSString, NSImage>
    
    private init() {
        self.cache = NSCache<NSString, NSImage>()
    }
    
    func loadImage(url: URL, completion: @escaping (NSImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        // Check if the image is already cached
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        // If not, download it
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = NSImage(data: data) {
                self.cache.setObject(image, forKey: key)
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
#else
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
#endif
