import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CleaningZoneViewModel()
    
    var body: some View {
        MainTabView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
