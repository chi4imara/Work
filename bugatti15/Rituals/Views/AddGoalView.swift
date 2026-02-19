import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Goal) -> Void
    
    @State private var title = ""
    @State private var selectedCategory: GoalCategory = .body
    @State private var selectedFrequency: GoalFrequency = .daily
    @State private var selectedIcon = "star.fill"
    @State private var description = ""
    @State private var showingIconPicker = false
    
    private let availableIcons = [
        "star.fill", "heart.fill", "sun.max.fill", "moon.fill",
        "leaf.fill", "drop.fill", "flame.fill", "snowflake",
        "figure.walk", "figure.run", "bicycle", "car.fill",
        "book.fill", "paintbrush.fill", "music.note", "camera.fill",
        "person.2.fill", "phone.fill", "message.fill", "envelope.fill"
    ]
    
    var isValidForm: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter goal title", text: $title)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(GoalCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        onTap: {
                                            selectedCategory = category
                                            selectedIcon = category.icon
                                        }
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Icon")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button("Choose Icon") {
                                    showingIconPicker = true
                                }
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.secondary)
                            }
                            
                            HStack {
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.secondary)
                                    .frame(width: 40, height: 40)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                                
                                Text("Selected icon")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequency")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 12) {
                                ForEach(GoalFrequency.allCases, id: \.self) { frequency in
                                    FrequencyButton(
                                        frequency: frequency,
                                        isSelected: selectedFrequency == frequency,
                                        onTap: {
                                            selectedFrequency = frequency
                                        }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Add a personal note...", text: $description, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Mini-Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newGoal = Goal(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            category: selectedCategory,
                            frequency: selectedFrequency,
                            icon: selectedIcon,
                            description: description.isEmpty ? nil : description
                        )
                        onSave(newGoal)
                        dismiss()
                    }
                    .foregroundColor(isValidForm ? AppColors.secondary : AppColors.textSecondary)
                    .disabled(!isValidForm)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingIconPicker) {
            IconPickerView(selectedIcon: $selectedIcon)
        }
    }
}

struct CategoryButton: View {
    let category: GoalCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.secondary : AppColors.textSecondary)
                
                Text(category.name)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.secondary.opacity(0.3) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.secondary : AppColors.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencyButton: View {
    let frequency: GoalFrequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(frequency.name)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.secondary : AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? AppColors.secondary : AppColors.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIcon: String
    
    private let availableIcons = [
        "star.fill", "heart.fill", "sun.max.fill", "moon.fill",
        "leaf.fill", "drop.fill", "flame.fill", "snowflake",
        "figure.walk", "figure.run", "bicycle", "car.fill",
        "book.fill", "paintbrush.fill", "music.note", "camera.fill",
        "person.2.fill", "phone.fill", "message.fill", "envelope.fill",
        "house.fill", "tree.fill", "tree.circle.fill", "sparkles"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                                dismiss()
                            }) {
                                Image(systemName: icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedIcon == icon ? AppColors.primary : AppColors.textSecondary)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIcon == icon ? AppColors.secondary : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedIcon == icon ? AppColors.secondary : AppColors.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.secondary)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AddGoalView { _ in }
}
