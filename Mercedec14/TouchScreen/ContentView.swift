import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var isLoading = true
    
    var body: some View {}
    
}

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
}
