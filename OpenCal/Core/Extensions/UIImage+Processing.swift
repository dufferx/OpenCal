import UIKit

extension UIImage {
    /// Fixes EXIF orientation so the model always sees the image right-side up
    func fixedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalized
    }

    /// Resizes image so the longest edge is at most maxDimension
    func resizedToMaxDimension(_ maxDimension: CGFloat) -> UIImage {
        let longestEdge = max(size.width, size.height)
        guard longestEdge > maxDimension else { return self }
        let scale = maxDimension / longestEdge
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return resized
    }
}
