import SwiftUI

struct AddHabitView: View {
    @StateObject private var viewModel = AddHabitViewModel()
    @Environment(\.dismiss) private var dismiss
    let onSave: (Habit) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Create New Habit")
                            .font(FontManager.bold(size: 24))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Build a habit that will boost your confidence and energy")
                            .font(FontManager.regular(size: 16))
                            .foregroundColor(ColorManager.darkGray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            TextField("Enter habit name", text: $viewModel.name)
                                .font(FontManager.regular(size: 16))
                                .padding(16)
                                .background(ColorManager.lightBlue)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    CategoryCard(
                                        category: category,
                                        isSelected: viewModel.selectedCategory == category
                                    ) {
                                        viewModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Icon")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                ForEach(viewModel.availableIcons, id: \.self) { icon in
                                    IconButton(
                                        icon: icon,
                                        isSelected: viewModel.selectedIcon == icon
                                    ) {
                                        viewModel.selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequency")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            HStack(spacing: 12) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    FrequencyButton(
                                        frequency: frequency,
                                        isSelected: viewModel.selectedFrequency == frequency
                                    ) {
                                        viewModel.selectedFrequency = frequency
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            TextField("This will help me...", text: $viewModel.whyImportant, axis: .vertical)
                                .font(FontManager.regular(size: 16))
                                .lineLimit(3...6)
                                .padding(16)
                                .background(ColorManager.lightBlue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
            }
            .background(ColorManager.backgroundGradient.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let habit = viewModel.createHabit()
                        onSave(habit)
                        dismiss()
                    }
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(viewModel.canSave ? ColorManager.primaryBlue : ColorManager.lightGray)
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}

struct CategoryCard: View {
    let category: HabitCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Text(category.title)
                    .font(FontManager.regular(size: 12))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorManager.primaryBlue.opacity(0.1) : ColorManager.lightBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorManager.primaryBlue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : ColorManager.primaryBlue)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? ColorManager.primaryBlue : ColorManager.lightBlue)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencyButton: View {
    let frequency: HabitFrequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(frequency.title)
                .font(FontManager.medium(size: 14))
                .foregroundColor(isSelected ? .white : ColorManager.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? ColorManager.primaryBlue : ColorManager.lightBlue)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddHabitView { _ in }
}
