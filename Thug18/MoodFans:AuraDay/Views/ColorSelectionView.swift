import SwiftUI

struct ColorSelectionView: View {
    let selectedDate: Date
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var dataManager = MoodDataManager.shared
    @State private var selectedColor: MoodColor?
    @State private var noteText: String = ""
    @State private var animateColors = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        colorPaletteView
                        
                        noteSection
                        
                        actionButtons
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, AppTheme.Spacing.lg)
                }
            }
        }
        .onAppear {
            loadExistingEntry()
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateColors = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                        Text("Cancel")
                    }
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.medium)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text("Choose Color")
                            .font(AppTheme.Fonts.navigationTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        if let selectedColor = selectedColor {
                            Circle()
                                .fill(selectedColor.color)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    Text("for \(dateFormatter.string(from: selectedDate))")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, AppTheme.Spacing.lg)
        }
        .background(Color.black.opacity(0.1))
    }
    
    private var colorPaletteView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("How are you feeling?")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.lg) {
                ForEach(Array(MoodColor.allCases.enumerated()), id: \.element) { index, color in
                    ColorOptionView(
                        color: color,
                        isSelected: selectedColor == color,
                        animationDelay: Double(index) * 0.1
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedColor = color
                        }
                    }
                    .opacity(animateColors ? 1.0 : 0.0)
                    .offset(y: animateColors ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(max(0, Double(index) * 0.1)), value: animateColors)
                }
            }
        }
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Add a note (optional)")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .frame(height: 100)
                
                if noteText.isEmpty {
                    Text("Add a comment (e.g., why you chose this color)...")
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                }
                
                TextEditor(text: $noteText)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .background(Color.clear)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .scrollContentBackground(.hidden)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button(action: saveEntry) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                    Text("Save Mood")
                        .font(AppTheme.Fonts.buttonFont)
                }
                .foregroundColor(selectedColor != nil ? AppTheme.Colors.backgroundBlue : AppTheme.Colors.tertiaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    selectedColor != nil ? AppTheme.Colors.accentYellow : Color.white.opacity(0.2)
                )
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(color: selectedColor != nil ? AppTheme.Colors.accentYellow.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            }
            .disabled(selectedColor == nil)
            .scaleEffect(selectedColor != nil ? 1.0 : 0.95)
            .animation(.easeInOut(duration: 0.2), value: selectedColor != nil)
            
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
            }
        }
    }
    
    private func loadExistingEntry() {
        if let existingEntry = dataManager.getEntry(for: selectedDate) {
            selectedColor = existingEntry.moodColor
            noteText = existingEntry.note
        }
    }
    
    private func saveEntry() {
        guard let color = selectedColor else { return }
        
        dataManager.addOrUpdateEntry(
            date: selectedDate,
            moodColor: color,
            note: noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        dismiss()
    }
}

struct ColorOptionView: View {
    let color: MoodColor
    let isSelected: Bool
    let animationDelay: Double
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.color)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .shadow(color: AppTheme.Shadow.medium, radius: 8, x: 0, y: 4)
                    
                    if isSelected {
                        Circle()
                            .stroke(AppTheme.Colors.accentYellow, lineWidth: 4)
                            .frame(width: 88, height: 88)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(textColor)
                    }
                }
                .scaleEffect(isPressed ? 0.9 : (isSelected ? 1.1 : 1.0))
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text(color.displayName)
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text(color.emotion)
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(Color.white.opacity(isSelected ? 0.15 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(Color.white.opacity(isSelected ? 0.3 : 0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    private var textColor: Color {
        switch color {
        case .yellow, .white:
            return Color.black
        default:
            return Color.white
        }
    }
}

#Preview {
    ColorSelectionView(selectedDate: Date(), isPresented: .constant(true))
}
