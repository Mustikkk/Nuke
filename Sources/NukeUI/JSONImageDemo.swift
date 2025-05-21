#if DEBUG
import SwiftUI
import Nuke

@available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
struct JSONImageDemo: View {
    let jsonImageURL = URL(string: "https://example.com/json-image")!
    
    var body: some View {
        VStack {
            Text("JSON Image Demo")
                .font(.headline)
            
            LazyImage(url: jsonImageURL) { state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Color.red
                        .overlay(
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.white)
                        )
                } else {
                    Color.gray
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                }
            }
            .enableJSONDecoding() // Enable JSON decoding for this image
            .frame(height: 300)
            .padding()
            
            Text("This example demonstrates loading an image that's embedded in a JSON response.")
                .font(.caption)
                .padding()
        }
    }
}

@available(iOS 15, tvOS 15, macOS 12, watchOS 8, *)
struct JSONImageDemo_Previews: PreviewProvider {
    static var previews: some View {
        JSONImageDemo()
    }
}
#endif 