import SwiftUI

struct ThemeSettingsView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var appColors = AppColors.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        themePreview
                        
                        colorSchemesSection
                        
                        accentColorsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Theme Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var themePreview: some View {
        VStack(spacing: 16) {
            Text("Preview")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(appColors.primaryOrange)
                    
                    Text("Sunny Day")
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                    
                    Spacer()
                    
                    Text("22°C")
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textSecondary)
                }
                
                HStack {
                    Image(systemName: "face.smiling")
                        .foregroundColor(appColors.primaryBlue)
                    
                    Text("Happy")
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                    
                    Spacer()
                    
                    Text("Great day!")
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
            }
            .padding(16)
            .background(appColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var colorSchemesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Schemes")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(ThemeManager.ColorScheme.allCases, id: \.self) { scheme in
                    ColorSchemeRow(
                        scheme: scheme,
                        isSelected: themeManager.selectedScheme == scheme
                    ) {
                        themeManager.selectedScheme = scheme
                    }
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var accentColorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Accent Colors")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(ThemeManager.AccentColor.allCases, id: \.self) { accent in
                    AccentColorButton(
                        accent: accent,
                        isSelected: themeManager.selectedAccent == accent
                    ) {
                        themeManager.selectedAccent = accent
                    }
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
}

struct ColorSchemeRow: View {
    let scheme: ThemeManager.ColorScheme
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(scheme.displayName)
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                    
                    Text(scheme.description)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(appColors.primaryOrange)
                }
            }
            .padding(16)
            .background(isSelected ? appColors.primaryOrange.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? appColors.primaryOrange : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct AccentColorButton: View {
    let accent: ThemeManager.AccentColor
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(accent.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                    )
                
                Text(accent.displayName)
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(appColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ThemeSettingsView()
}
