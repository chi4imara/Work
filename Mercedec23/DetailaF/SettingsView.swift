import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        appInfoSection
                        supportSection
                        legalSection
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(AppColors.textBlue)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.backgroundWhite)
                )
            
            VStack(spacing: 4) {
                Text("AccessorizeHer")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
                
                Text("Version 1.0.0")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
            }
            
            Text("Discover the perfect accessories for any outfit, try virtual looks, save your favorites, and create stylish combinations effortlessly.")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                iconColor: AppColors.primaryYellow,
                showChevron: true
            ) {
                viewModel.rateApp()
            }
            
            Divider()
                .padding(.leading, 50)
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                iconColor: AppColors.accentPink,
                showChevron: true
            ) {
                viewModel.contactSupport()
            }
        }
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "doc.text.fill",
                title: "Privacy Policy",
                iconColor: AppColors.textBlue,
                showChevron: true
            ) {
                viewModel.openPrivacyPolicy()
            }
        }
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textBlue)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
            }
            .padding(.horizontal, AppConstants.cardPadding)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OriginalSettingsButton: View {
    let item: SettingsItem
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(item.color)
                        .frame(width: 60, height: 60)
                        .shadow(color: item.color.opacity(0.4), radius: isPressed ? 15 : 8, x: 0, y: isPressed ? 8 : 4)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(item.title)
                    .font(.playfairDisplay(12, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct SettingsItem {
    let type: SettingsType
    let icon: String
    let title: String
    let color: Color
}

enum SettingsType {
    case rate
    case contact
    case privacy
    case share
}

#Preview {
    SettingsView()
}
