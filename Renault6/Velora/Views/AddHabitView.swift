import SwiftUI

struct AddHabitView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName = ""
    @State private var selectedCategory: HabitCategory = .meditation
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var whyImportant = ""
    @State private var selectedIcon = "heart.fill"
    
    private let availableIcons = [
        "heart.fill", "leaf.fill", "star.fill", "sun.max.fill",
        "moon.fill", "wind", "drop.fill", "flame.fill",
        "book.fill", "pencil", "target", "checkmark.circle.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter habit name", text: $habitName)
                                .font(.ubuntu(16, weight: .light))
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        HStack {
                                            Image(systemName: category.iconName)
                                                .font(.system(size: 20))
                                                .foregroundColor(selectedCategory == category ? AppColors.accentText : AppColors.primaryText)
                                            
                                            Text(category.rawValue)
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(selectedCategory == category ? AppColors.accentText : AppColors.primaryText)
                                            
                                            Spacer()
                                        }
                                        .padding(16)
                                        .background(
                                            selectedCategory == category 
                                            ? AppColors.primaryAccent
                                            : AppColors.cardBackground
                                        )
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Icon")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedIcon == icon ? AppColors.accentText : AppColors.primaryText)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                selectedIcon == icon 
? AppColors.primaryAccent
                                            : AppColors.cardBackground
                                            )
                                            .cornerRadius(22)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequency")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    Button(action: {
                                        selectedFrequency = frequency
                                    }) {
                                        HStack {
                                            Image(systemName: selectedFrequency == frequency ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(selectedFrequency == frequency ? AppColors.success : AppColors.primaryText.opacity(0.6))
                                            
                                            Text(frequency.rawValue)
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            Spacer()
                                        }
                                        .padding(16)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("This helps me because...", text: $whyImportant, axis: .vertical)
                                .font(.ubuntu(14, weight: .light))
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(habitName.isEmpty ? AppColors.primaryText.opacity(0.5) : AppColors.primaryText)
                    .disabled(habitName.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(
            name: habitName,
            category: selectedCategory,
            iconName: selectedIcon,
            frequency: selectedFrequency,
            whyImportant: whyImportant,
            createdDate: Date(),
            completedDates: [],
            isActive: true
        )
        
        viewModel.addHabit(newHabit)
        dismiss()
    }
}

#Preview {
    AddHabitView(viewModel: AppViewModel())
}
