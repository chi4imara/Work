import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = CollectionViewModel()
    @State private var selectedTab: TabItem = .collection
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .collection:
                        CollectionView(viewModel: viewModel)
                    case .sets:
                        SetsView(viewModel: viewModel)
                    case .lists:
                        ListsView(viewModel: viewModel)
                    case .settings:
                        SettingsView(viewModel: viewModel)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(Color.buttonGradient)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 120)
                    .opacity(selectedTab == .collection ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $showingAddItem) {
            ItemDetailView(viewModel: viewModel, item: CollectionItem(), isPresented: $showingAddItem)
        }
    }
}

#Preview {
    MainView()
}
