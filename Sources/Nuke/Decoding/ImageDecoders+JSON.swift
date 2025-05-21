// The MIT License (MIT)
//
// Copyright (c) 2015-2024 Alexander Grebenyuk (github.com/kean).

import Foundation

extension ImageDecoders {
    /// A decoder that supports images inside JSON responses where the image data
    /// is stored as a Base64 encoded string under the "image" key.
    ///
    /// Example JSON format:
    /// ```
    /// {
    ///     "image": "base64EncodedImageData..."
    /// }
    /// ```
    public final class JSON: ImageDecoding, @unchecked Sendable {
        private var scale: CGFloat = 1.0
        private var thumbnail: ImageRequest.ThumbnailOptions?
        private let lock = NSLock()
        
        public var isAsynchronous: Bool { thumbnail != nil }
        
        public init() { }
        
        public init?(context: ImageDecodingContext) {
            guard isJSONResponse(context.data) else {
                return nil // Not a JSON response
            }
            
            self.scale = context.request.scale.map { CGFloat($0) } ?? self.scale
            self.thumbnail = context.request.thumbnail
        }
        
        public func decode(_ data: Data) throws -> ImageContainer {
            lock.lock()
            defer { lock.unlock() }
            
            guard let imageData = extractImageData(from: data) else {
                throw ImageDecodingError.unknown
            }
            
            // Use the default decoder to decode the actual image data
            let decoder = ImageDecoders.Default()
            return try decoder.decode(imageData)
        }
        
        private func isJSONResponse(_ data: Data) -> Bool {
            guard let firstChar = data.first else { return false }
            // Quick check for JSON start character '{' or '['
            return firstChar == 0x7B || firstChar == 0x5B
        }
        
        private func extractImageData(from data: Data) -> Data? {
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let base64String = json["image"] as? String,
                  let imageData = Data(base64Encoded: base64String) else {
                return nil
            }
            return imageData
        }
    }
} 