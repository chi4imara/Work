import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("This view is not used in the main app")
            .font(.ubuntu(size: 16, weight: .regular))
            .foregroundColor(.gray)
    }
}

#Preview {
    ContentView()
}
