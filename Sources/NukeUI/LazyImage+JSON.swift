// The MIT License (MIT)
//
// Copyright (c) 2015-2024 Alexander Grebenyuk (github.com/kean).

import Foundation
import Nuke
import SwiftUI

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 10.16, *)
extension LazyImage {
    /// Enables JSON decoding support for this LazyImage instance.
    /// 
    /// This allows LazyImage to properly handle responses where the image is base64-encoded
    /// inside a JSON object under the "image" key:
    /// ```
    /// {
    ///     "image": "base64EncodedImageData..."
    /// }
    /// ```
    public func enableJSONDecoding() -> Self {
        // Register the JSON decoder if it hasn't been registered yet
        registerJSONDecoderIfNeeded()
        return self
    }
}

/// Registers the JSON image decoder in the shared image decoder registry.
///
/// This function is idempotent - it will only register the decoder once
/// even if called multiple times.
private func registerJSONDecoderIfNeeded() {
    // Use a static property to ensure we only register the decoder once
    struct Static {
        static var registeredJSONDecoder = false
    }
    
    if !Static.registeredJSONDecoder {
        ImageDecoderRegistry.shared.register { context in
            ImageDecoders.JSON(context: context)
        }
        Static.registeredJSONDecoder = true
    }
} 