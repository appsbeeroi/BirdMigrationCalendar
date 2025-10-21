import UIKit

extension UIImage {
    func compressedToOneTenth() -> UIImage? {
        let targetScale: CGFloat = 0.5 
        let newSize = CGSize(width: size.width * targetScale, height: size.height * targetScale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let resized = resizedImage,
              let compressedData = resized.jpegData(compressionQuality: 0.25) else { return nil }
        
        return UIImage(data: compressedData)
    }
}
