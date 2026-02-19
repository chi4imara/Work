import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.white)
                    
                    Spacer()
                }
                .padding(.horizontal, DesignConstants.Spacing.lg)
                .padding(.vertical, DesignConstants.Spacing.md)
                
                ScrollView {
                    VStack(spacing: DesignConstants.Spacing.xl) {
                        AppInfoSection()
                        
                        SettingsOptionsSection(viewModel: viewModel)
                        
                        AppVersionSection()
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    .padding(.top, DesignConstants.Spacing.xl)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample Data", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct LoadSampleDataSection: View {
    let onLoad: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
            Text("Testing")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
            
            Button(action: onLoad) {
                HStack(spacing: DesignConstants.Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(DesignConstants.Colors.lightGreen.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 20))
                            .foregroundColor(DesignConstants.Colors.lightGreen)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Load sample data")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(DesignConstants.Colors.white)
                        
                        Text("Add test habits and 7 days of history")
                            .font(.ubuntu(14))
                            .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
                }
                .padding(DesignConstants.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                        .fill(DesignConstants.Colors.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                                .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                DesignConstants.Colors.primaryYellow,
                                DesignConstants.Colors.lightGreen
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 40))
                    .foregroundColor(DesignConstants.Colors.primaryBlue)
            }
            
            VStack(spacing: DesignConstants.Spacing.sm) {
                Text(AppConstants.appName)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Text("Your daily energy companion")
                    .font(.ubuntu(16))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct SettingsOptionsSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.md) {
            SettingsOptionView(
                icon: SettingsOption.privacyPolicy.icon,
                title: SettingsOption.privacyPolicy.rawValue,
                color: DesignConstants.Colors.softPurple
            ) {
                viewModel.openURL(SettingsOption.privacyPolicy.url)
            }
            
            SettingsOptionView(
                icon: SettingsOption.contactEmail.icon,
                title: SettingsOption.contactEmail.rawValue,
                color: DesignConstants.Colors.lightBlue
            ) {
                viewModel.openURL(SettingsOption.contactEmail.url)
            }
            
            SettingsOptionView(
                icon: SettingsOption.rateApp.icon,
                title: SettingsOption.rateApp.rawValue,
                color: DesignConstants.Colors.primaryYellow
            ) {
                viewModel.requestAppReview()
            }
        }
    }
}

struct SettingsOptionView: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: DesignConstants.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
            }
            .padding(DesignConstants.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                    .fill(DesignConstants.Colors.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                            .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }
}

struct AppVersionSection: View {
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.sm) {
            Text("Made with ❤️ for your daily energy")
                .font(.ubuntu(12))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
    }
}

struct CreativeSettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            ScrollView {
                VStack(spacing: DesignConstants.Spacing.xl) {
                    FloatingHeaderView()
                    
                    HexagonalOptionsView(viewModel: viewModel)
                    
                    CircularInfoView()
                }
                .padding(.horizontal, DesignConstants.Spacing.lg)
                .padding(.top, DesignConstants.Spacing.xl)
                .padding(.bottom, 100)
            }
        }
    }
}

struct FloatingHeaderView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.lg) {
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(DesignConstants.Colors.primaryYellow.opacity(0.1))
                        .frame(width: 60 + CGFloat(index) * 20, height: 60 + CGFloat(index) * 20)
                        .offset(
                            x: isAnimating ? CGFloat.random(in: -10...10) : 0,
                            y: isAnimating ? CGFloat.random(in: -10...10) : 0
                        )
                        .animation(
                            Animation.easeInOut(duration: 2 + Double(index))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: isAnimating
                        )
                }
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40))
                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 20).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }
            
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(DesignConstants.Colors.white)
        }
    }
}

struct HexagonalOptionsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.lg) {
            HexagonOptionView(
                option: .privacyPolicy,
                position: .top
            ) {
                viewModel.openURL(SettingsOption.privacyPolicy.url)
            }
            
            HStack(spacing: DesignConstants.Spacing.xl) {
                HexagonOptionView(
                    option: .contactEmail,
                    position: .left
                ) {
                    viewModel.openURL(SettingsOption.contactEmail.url)
                }
                
                Spacer()
                
                HexagonOptionView(
                    option: .rateApp,
                    position: .right
                ) {
                    viewModel.requestAppReview()
                }
            }
        }
    }
}

struct HexagonOptionView: View {
    let option: SettingsOption
    let position: HexagonPosition
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
                rotationAngle += 60
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: DesignConstants.Spacing.sm) {
                ZStack {
                    HexagonShape()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    getColorForOption().opacity(0.3),
                                    getColorForOption().opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.easeInOut(duration: 0.5), value: rotationAngle)
                    
                    HexagonShape()
                        .stroke(getColorForOption(), lineWidth: 2)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 24))
                        .foregroundColor(getColorForOption())
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
                
                Text(option.rawValue)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getColorForOption() -> Color {
        switch option {
        case .privacyPolicy:
            return DesignConstants.Colors.softPurple
        case .contactEmail:
            return DesignConstants.Colors.lightBlue
        case .rateApp:
            return DesignConstants.Colors.primaryYellow
        }
    }
}

enum HexagonPosition {
    case top, left, right
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct CircularInfoView: View {
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.lg) {
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(
                            DesignConstants.Colors.primaryYellow.opacity(0.1 + Double(index) * 0.1),
                            lineWidth: 2
                        )
                        .frame(width: 100 + CGFloat(index) * 30, height: 100 + CGFloat(index) * 30)
                        .rotationEffect(.degrees(rotationAngle * (index % 2 == 0 ? 1 : -1)))
                        .animation(
                            Animation.linear(duration: 10 + Double(index) * 5)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                }
                
                VStack(spacing: 4) {
                    Text("v1.0.0")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.primaryYellow)
                    
                    Text("Energy Day")
                        .font(.ubuntu(12))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                }
            }
            .onAppear {
                rotationAngle = 360
            }
            
            Text("Crafted with care for your daily wellness journey")
                .font(.ubuntu(14))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppViewModel())
}
