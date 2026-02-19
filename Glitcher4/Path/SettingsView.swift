import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @State private var showingClearAlert = false
    @State private var showingLoadSampleAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text("App preferences and info")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                .padding(.top, 20)
                .padding(.bottom, 32)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    iconColor: AppColors.orange
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                    .background(AppColors.white.opacity(0.1))
                                
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    iconColor: AppColors.lightBlue
                                ) {
                                    openURL("https://forms.gle/omk4TKNvmtT2Naiw5")
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "hand.raised.fill",
                                title: "Privacy Policy",
                                iconColor: AppColors.green
                            ) {
                                openURL("https://www.freeprivacypolicy.com/live/20057951-5882-4f2d-8166-553f15e71903")
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Fitness Tracker")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white.opacity(0.7))
                        }
                        .padding(.top, 32)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load", role: .none) {
                workoutViewModel.loadSampleData()
            }
        } message: {
            Text("This will replace all existing workouts with sample data. Continue?")
        }
        .alert("Clear All Data", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                workoutViewModel.clearAllWorkouts()
            }
        } message: {
            Text("Are you sure you want to delete all workouts? This action cannot be undone.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isPressed ? AppColors.white.opacity(0.05) : Color.clear)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    SettingsView(workoutViewModel: WorkoutViewModel())
}
