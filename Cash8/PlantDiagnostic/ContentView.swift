import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}

#Preview {
    ContentView()
}
