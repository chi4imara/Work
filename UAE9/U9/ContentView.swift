import SwiftUI

struct ContentView: View {
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        MainTabView()
            .environmentObject(productViewModel)
    }
}

#Preview {
    ContentView()
}
