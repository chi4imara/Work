import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @ObservedObject var viewModel: AppViewModel
    @State private var showingLoadSampleAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(.bold, size: 28))
                        .foregroundColor(.primaryBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        HStack(spacing: 16) {
                            SettingsCard(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                color: .primaryBlue,
                                height: 120
                            ) {
                                openURL("https://www.privacypolicies.com/live/9ebf1c9a-b74b-47fa-b6e6-9e0ca609857c")
                            }
                            
                            SettingsCard(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: .softPink,
                                height: 120
                            ) {
                                openURL("https://www.privacypolicies.com/live/9ebf1c9a-b74b-47fa-b6e6-9e0ca609857c")
                            }
                        }
                        
                        SettingsCard(
                            title: "Rate App",
                            icon: "star.fill",
                            color: .primaryYellow,
                            height: 100
                        ) {
                            requestReview()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                }
            }
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                viewModel.loadSampleData()
            }
        } message: {
            Text("This will replace your current places, tasks and challenges with sample data for testing.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.playfairDisplay(.semibold, size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct WideSettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(.semibold, size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(.regular, size: 12))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct CircularSettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.playfairDisplay(.medium, size: 12))
                    .foregroundColor(.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView(viewModel: AppViewModel())
}
