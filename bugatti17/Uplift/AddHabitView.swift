import SwiftUI

struct AddHabitView: View {
    @StateObject private var viewModel = AddHabitViewModel()
    @Environment(\.dismiss) private var dismiss
    let onSave: (Habit) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                ScrollView {
                    VStack(spacing: DesignConstants.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Habit Name")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Enter habit name", text: $viewModel.title)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignConstants.Spacing.sm) {
                                ForEach(AppConstants.habitCategories, id: \.id) { category in
                                    CategorySelectionView(
                                        category: category,
                                        isSelected: viewModel.selectedCategory.id == category.id
                                    ) {
                                        viewModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Icon")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: DesignConstants.Spacing.sm) {
                                ForEach(habitIcons, id: \.self) { icon in
                                    IconSelectionView(
                                        icon: icon,
                                        isSelected: viewModel.selectedIcon == icon
                                    ) {
                                        viewModel.selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Frequency")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            HStack(spacing: DesignConstants.Spacing.sm) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    FrequencySelectionView(
                                        frequency: frequency,
                                        isSelected: viewModel.selectedFrequency == frequency
                                    ) {
                                        viewModel.selectedFrequency = frequency
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Why is this important? (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Add a note...", text: $viewModel.note, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                                .lineLimit(3...6)
                        }
                    }
                    .padding(DesignConstants.Spacing.lg)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignConstants.Colors.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let habit = viewModel.createHabit()
                        onSave(habit)
                        dismiss()
                    }
                    .foregroundColor(viewModel.canSave ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
    
    private let habitIcons = [
        "checkmark.circle.fill",
        "heart.fill",
        "star.fill",
        "flame.fill",
        "drop.fill",
        "leaf.fill",
        "moon.fill",
        "sun.max.fill",
        "figure.walk",
        "book.fill",
        "music.note",
        "paintbrush.fill"
    ]
}

struct CategorySelectionView: View {
    let category: HabitCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignConstants.Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                
                Text(category.name)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                    .fill(isSelected ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.1))
            )
        }
    }
}

struct IconSelectionView: View {
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                        .fill(isSelected ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.1))
                )
        }
    }
}

struct FrequencySelectionView: View {
    let frequency: HabitFrequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(frequency.displayName)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                .padding(.horizontal, DesignConstants.Spacing.md)
                .padding(.vertical, DesignConstants.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                        .fill(isSelected ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.1))
                )
        }
    }
}

struct AddChallengeView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = AppConstants.habitCategories[0]
    @Environment(\.dismiss) private var dismiss
    let onSave: (MiniChallenge) -> Void
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                ScrollView {
                    VStack(spacing: DesignConstants.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Challenge Title")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Enter challenge title", text: $title)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Description")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Describe the challenge", text: $description, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignConstants.Spacing.sm) {
                                ForEach(AppConstants.habitCategories, id: \.id) { category in
                                    CategorySelectionView(
                                        category: category,
                                        isSelected: selectedCategory.id == category.id
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                    }
                    .padding(DesignConstants.Spacing.lg)
                }
            }
            .navigationTitle("New Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignConstants.Colors.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let challenge = MiniChallenge(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                            category: selectedCategory.id
                        )
                        onSave(challenge)
                        dismiss()
                    }
                    .foregroundColor(canSave ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    AddHabitView { habit in
        print("Saved habit: \(habit.title)")
    }
}
