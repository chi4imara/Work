import SwiftUI

struct AddRitualView: View {
    let viewModel: MoodViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var ritualName = ""
    @State private var selectedCategory: Ritual.RitualCategory = .meditation
    @State private var selectedFrequency: Ritual.Frequency = .daily
    @State private var ritualDescription = ""
    @State private var showingSuccessMessage = false
    
    var isFormValid: Bool {
        !ritualName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.sm) {
                            Text("Create New Ritual")
                                .font(AppFonts.playfairBold(size: 24))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Build a healthy habit that supports your wellbeing")
                                .font(AppFonts.playfairRegular(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, AppSpacing.lg)
                        
                        VStack(spacing: AppSpacing.lg) {
                            FormSection(title: "Ritual Name") {
                                TextField("Enter ritual name", text: $ritualName)
                                    .font(AppFonts.playfairRegular(size: 16))
                                    .padding(AppSpacing.md)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(AppRadius.md)
                            }
                            
                            FormSection(title: "Category") {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppSpacing.sm) {
                                    ForEach(Ritual.RitualCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category,
                                            action: {
                                                withAnimation(AppAnimations.bouncy) {
                                                    selectedCategory = category
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            
                            FormSection(title: "Frequency") {
                                VStack(spacing: AppSpacing.sm) {
                                    ForEach(Ritual.Frequency.allCases, id: \.self) { frequency in
                                        FrequencyButton(
                                            frequency: frequency,
                                            isSelected: selectedFrequency == frequency,
                                            action: {
                                                withAnimation(AppAnimations.smooth) {
                                                    selectedFrequency = frequency
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            
                            FormSection(title: "Why is this important? (Optional)") {
                                TextField("Describe why this ritual matters to you", text: $ritualDescription, axis: .vertical)
                                    .font(AppFonts.playfairRegular(size: 14))
                                    .padding(AppSpacing.md)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(AppRadius.md)
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xl)
                        
                        VStack(spacing: AppSpacing.md) {
                            Button(action: {
                                saveRitual()
                            }) {
                                HStack {
                                    Text("Save Ritual")
                                        .font(AppFonts.playfairSemiBold(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    isFormValid ? 
                                    LinearGradient(
                                        colors: [AppColors.primary, AppColors.accent],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) :
                                    LinearGradient(
                                        colors: [AppColors.textSecondary.opacity(0.3), AppColors.textSecondary.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(AppRadius.lg)
                                .shadow(
                                    color: isFormValid ? AppColors.primary.opacity(0.3) : Color.clear,
                                    radius: 10,
                                    x: 0,
                                    y: 5
                                )
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Cancel")
                                    .font(AppFonts.playfairMedium(size: 16))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func saveRitual() {
        let newRitual = Ritual(
            name: ritualName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            frequency: selectedFrequency,
            description: ritualDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            createdDate: Date()
        )
        
        viewModel.addRitual(newRitual)
        
        withAnimation(AppAnimations.smooth) {
            showingSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.playfairSemiBold(size: 16))
                .foregroundColor(AppColors.textPrimary)
            
            content
        }
    }
}

struct CategoryButton: View {
    let category: Ritual.RitualCategory
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(AppAnimations.quick) {
                isPressed = true
            }
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: category.systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                
                Text(category.displayName)
                    .font(AppFonts.playfairMedium(size: 12))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.sm)
            .background(
                isSelected ? 
                AppColors.primary.opacity(0.1) : 
                AppColors.cardBackground
            )
            .cornerRadius(AppRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(
                        isSelected ? AppColors.primary : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .animation(AppAnimations.bouncy, value: isSelected)
        .animation(AppAnimations.quick, value: isPressed)
    }
}

struct FrequencyButton: View {
    let frequency: Ritual.Frequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(frequency.displayName)
                    .font(AppFonts.playfairMedium(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(
                isSelected ? 
                AppColors.primary.opacity(0.1) : 
                AppColors.cardBackground
            )
            .cornerRadius(AppRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(
                        isSelected ? AppColors.primary : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .animation(AppAnimations.smooth, value: isSelected)
    }
}

#Preview {
    AddRitualView(viewModel: MoodViewModel())
}
