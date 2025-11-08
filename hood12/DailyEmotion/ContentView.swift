import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            .environmentObject(EmotionDataManager())
    }
}

#Preview {
    ContentView()
}
