import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var selectedTab: TabItem = .outfits
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .outfits:
                        OutfitsView(viewModel: viewModel)
                    case .seasons:
                        SeasonsView(viewModel: viewModel)
                    case .notes:
                        NotesView(viewModel: viewModel)
                    case .settings:
                        SettingsView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct ExtraView: View {
    @ObservedObject var viewModel: OutfitViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(Color.theme.primaryYellow)
                    
                    Text("Extra Features")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("This section is reserved for future features and enhancements to make your style journey even better!")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button("Add Sample Data") {
                        viewModel.addSampleData()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.buttonText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.theme.buttonBackground)
                            .shadow(color: Color.theme.shadowColor, radius: 6, x: 0, y: 3)
                    )
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainTabView(viewModel: OutfitViewModel())
}
