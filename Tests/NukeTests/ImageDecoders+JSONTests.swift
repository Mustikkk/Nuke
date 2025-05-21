// The MIT License (MIT)
//
// Copyright (c) 2015-2024 Alexander Grebenyuk (github.com/kean).

import XCTest
@testable import Nuke

final class ImageDecodersJSONTests: XCTestCase {
    func testJSONDecoderRecognizesJSONFormat() {
        // Given a JSON with an image property
        let json = """
        {
            "image": "\(mockBase64Image())"
        }
        """
        let data = json.data(using: .utf8)!
        
        // When we create a context
        let context = ImageDecodingContext(
            request: ImageRequest(url: URL(string: "https://example.com")!),
            data: data
        )
        
        // Then JSON decoder recognizes it
        XCTAssertNotNil(ImageDecoders.JSON(context: context))
    }
    
    func testJSONDecoderExtractsImage() throws {
        // Given a JSON with an image property
        let json = """
        {
            "image": "\(mockBase64Image())"
        }
        """
        let data = json.data(using: .utf8)!
        
        // When
        let context = ImageDecodingContext(
            request: ImageRequest(url: URL(string: "https://example.com")!),
            data: data
        )
        
        let decoder = ImageDecoders.JSON(context: context)!
        let container = try decoder.decode(data)
        
        // Then decoded image is not nil
        XCTAssertNotNil(container.image)
    }
    
    func testJSONDecoderFailsWithInvalidJSON() {
        // Given an invalid JSON 
        let invalidJSON = "{ image: invalid_json }"
        let data = invalidJSON.data(using: .utf8)!
        
        // When
        let context = ImageDecodingContext(
            request: ImageRequest(url: URL(string: "https://example.com")!),
            data: data
        )
        
        let decoder = ImageDecoders.JSON(context: context)!
        
        // Then decoding throws an error
        XCTAssertThrowsError(try decoder.decode(data))
    }
    
    func testJSONDecoderFailsWithMissingImageKey() {
        // Given a JSON without image key
        let json = """
        {
            "other_key": "value"
        }
        """
        let data = json.data(using: .utf8)!
        
        // When
        let context = ImageDecodingContext(
            request: ImageRequest(url: URL(string: "https://example.com")!),
            data: data
        )
        
        let decoder = ImageDecoders.JSON(context: context)!
        
        // Then decoding throws an error
        XCTAssertThrowsError(try decoder.decode(data))
    }
    
    func testJSONDecoderFailsWithInvalidBase64() {
        // Given a JSON with invalid base64 in image key
        let json = """
        {
            "image": "invalid_base64"
        }
        """
        let data = json.data(using: .utf8)!
        
        // When
        let context = ImageDecodingContext(
            request: ImageRequest(url: URL(string: "https://example.com")!),
            data: data
        )
        
        let decoder = ImageDecoders.JSON(context: context)!
        
        // Then decoding throws an error
        XCTAssertThrowsError(try decoder.decode(data))
    }
    
    // Helper function to create a minimal valid base64 encoded PNG image
    private func mockBase64Image() -> String {
        // This is a minimal 1x1 transparent PNG
        return "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=="
    }
} 