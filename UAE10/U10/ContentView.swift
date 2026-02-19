import SwiftUI

struct ContentView: View {
    var body: some View {
        AppRootView()
            .environmentObject(MeasurementStore())
    }
}

#Preview {
    ContentView()
}
