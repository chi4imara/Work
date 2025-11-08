import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    let selectedDate: Date
    
    @State private var selectedColor: WeatherColor?
    @State private var animateColors = false
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                VStack(spacing: AppSpacing.sm) {
                    Text("Choose Color for")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(dateFormatter.string(from: selectedDate))
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                .padding(.top, AppSpacing.lg)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.md), count: 3), spacing: AppSpacing.md) {
                    ForEach(Array(WeatherColor.predefinedColors.enumerated()), id: \.element.id) { index, color in
                        ColorOptionView(
                            color: color,
                            isSelected: selectedColor?.id == color.id,
                            animationDelay: Double(index) * 0.1
                        ) {
                            print("Color selected: \(color.displayName)")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedColor = color
                            }
                            print("Selected color after update: \(selectedColor?.displayName ?? "nil")")
                        }
                        .scaleEffect(animateColors ? 1.0 : 0.5)
                        .opacity(animateColors ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.05), value: animateColors)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer()
                
                VStack(spacing: AppSpacing.md) {
                    Button {
                        print("Save button tapped")
                        print("Selected color: \(selectedColor?.displayName ?? "nil")")
                        if let color = selectedColor {
                            print("Saving color: \(color.displayName) for date: \(selectedDate)")
                            HapticFeedback.shared.success()
                            weatherData.addEntry(date: selectedDate, weatherColor: color)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                dismiss()
                            }
                        } else {
                            print("No color selected - showing warning")
                            HapticFeedback.shared.warning()
                        }
                    } label: {
                        Text("Save")
                            .font(AppFonts.button)
                            .foregroundColor(selectedColor != nil ? AppColors.primaryText : AppColors.primaryText.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(selectedColor != nil ? AppColors.primaryOrange : AppColors.primaryOrange.opacity(0.3))
                            .cornerRadius(AppCornerRadius.medium)
                    }
                    .disabled(selectedColor == nil)
                    .scaleEffect(selectedColor != nil ? 1.0 : 0.95)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(Color.clear)
                            .cornerRadius(AppCornerRadius.medium)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .onAppear {
            if let existingEntry = weatherData.getEntry(for: selectedDate) {
                selectedColor = existingEntry.weatherColor
            }
            
            withAnimation(.easeInOut(duration: 0.6)) {
                animateColors = true
            }
        }
    }
}

struct ColorOptionView: View {
    let color: WeatherColor
    let isSelected: Bool
    let animationDelay: Double
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.shared.light()
            action()
        }) {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.swiftUIColor)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(AppColors.primaryText, lineWidth: isSelected ? 4 : 0)
                        )
                        .overlay(
                            Circle()
                                .fill(AppColors.primaryText.opacity(0.2))
                                .frame(width: 70, height: 70)
                                .opacity(isPressed ? 1 : 0)
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .shadow(color: isSelected ? AppColors.primaryOrange.opacity(0.5) : Color.clear, radius: isSelected ? 8 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                            .fontWeight(.bold)
                            .scaleEffect(1.2)
                    }
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                
                Text(color.displayName)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ColorPickerView(
        weatherData: WeatherDataManager(),
        appState: AppStateManager(),
        selectedDate: Date()
    )
}
