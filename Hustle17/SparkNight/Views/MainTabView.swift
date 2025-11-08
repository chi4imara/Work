import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var animateButtons = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("Party Assistant")
                            .font(.theme.largeTitle)
                            .foregroundColor(ColorTheme.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Choose your party tool")
                            .font(.theme.callout)
                            .foregroundColor(ColorTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .opacity(animateButtons ? 1.0 : 0.0)
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectedTab = 1
                            }
                        }) {
                            HomeActionButton(
                                title: "Wheel of Fortune",
                                subtitle: "Random task selector",
                                icon: "circle.grid.cross.fill",
                                gradient: ColorTheme.blueGradient,
                                delay: 0.1
                            )
                        }
                        .scaleEffect(animateButtons ? 1.0 : 0.8)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        .buttonStyle(ScaleButtonStyle())
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectedTab = 2
                            }
                        }) {
                            HomeActionButton(
                                title: "Theme Generator",
                                subtitle: "Party atmosphere ideas",
                                icon: "theatermasks.fill",
                                gradient: LinearGradient(
                                    colors: [ColorTheme.accentPink, ColorTheme.accentPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                delay: 0.2
                            )
                        }
                        .scaleEffect(animateButtons ? 1.0 : 0.8)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    
                    if viewModel.statistics.hasData {
                        VStack(spacing: 15) {
                            Text("Quick Stats")
                                .font(.theme.headline)
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            HStack(spacing: 20) {
                                QuickStatView(
                                    title: "Spins",
                                    value: "\(viewModel.statistics.wheelSpins)",
                                    icon: "circle.grid.cross"
                                )
                                
                                QuickStatView(
                                    title: "Themes",
                                    value: "\(viewModel.statistics.themesGenerated)",
                                    icon: "theatermasks"
                                )
                                
                                QuickStatView(
                                    title: "Favorites",
                                    value: "\(viewModel.favorites.count)",
                                    icon: "heart"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .scaleEffect(animateButtons ? 1.0 : 0.8)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        .onTapGesture {
                            viewModel.selectedTab = 4
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateButtons = true
            }
        }
    }
}

struct HomeActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let delay: Double
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(ColorTheme.backgroundWhite.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(ColorTheme.textLight)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.theme.title3)
                    .foregroundColor(ColorTheme.textLight)
                
                Text(subtitle)
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.textLight.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ColorTheme.textLight.opacity(0.7))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(gradient)
        .cornerRadius(20)
        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

struct QuickStatView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.primaryBlue)
            
            Text(value)
                .font(.theme.title2)
                .foregroundColor(ColorTheme.textPrimary)
            
            Text(title)
                .font(.theme.caption1)
                .foregroundColor(ColorTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        )
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
    HomeView(viewModel: AppViewModel())
}
