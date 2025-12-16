import SwiftUI

struct ContentView: View {
    var body: some View {
        AppRootView()
            .environmentObject(DataManager.shared)
    }
}

#Preview {
    ContentView()
}
