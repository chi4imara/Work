import SwiftUI

struct MainTabView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var store: CollectionStore
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                Group {
                    switch appState.selectedTab {
                    case 0:
                        CollectionsView(store: store)
                    case 1:
                        FavoritesView(appState: appState, store: store)
                    case 2:
                        StatisticsView(store: store)
                    case 3:
                        SettingsView(store: store)
                    default:
                        CollectionsView(store: store)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
        .overlay(
            VStack {
                Spacer()
                
                if store.showToast {
                    ToastView(message: store.toastMessage)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: store.showToast)
                }
            }
            .padding(.bottom, 120)
        )
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.bodyMedium)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.textPrimary.opacity(0.8))
            )
            .padding(.horizontal, 20)
    }
}

#Preview {
    MainTabView(appState: AppState(), store: CollectionStore())
}
