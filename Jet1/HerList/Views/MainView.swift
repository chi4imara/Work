import SwiftUI

struct MainView: View {
    @StateObject private var womenViewModel = WomenViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    InspirationsView(viewModel: womenViewModel, selectedTab: $selectedTab)
                case 1:
                    QuotesView(viewModel: womenViewModel)
                case 2:
                    NotesView(viewModel: notesViewModel)
                case 3:
                    AddEntryView(viewModel: womenViewModel, selectedTab: $selectedTab)
                case 4:
                    SettingsView()
                default:
                    InspirationsView(viewModel: womenViewModel, selectedTab: $selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}
