import SwiftUI
import GLib

@main
struct MyKittyApp: App {
    @StateObject private var petStore = PetStore()
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @State private var showSplash = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ZStack {
                    if !isOnboardingComplete {
                        OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    } else {
                        MainTabView()
                            .environmentObject(petStore)
                    }
                }
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        PetsListView(petStore: petStore)
                    case 1:
                        RecordsListView(petStore: petStore)
                    case 2:
                        ArchiveView(petStore: petStore)
                    case 3:
                        SettingsView()
                    default:
                        PetsListView(petStore: petStore)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}
