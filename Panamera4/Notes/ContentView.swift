import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            .environmentObject(ProcedureStore())
    }
}

#Preview {
    ContentView()
}
