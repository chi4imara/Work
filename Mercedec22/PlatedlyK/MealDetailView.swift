import SwiftUI

struct MealDetailView: View {
    let mealId: UUID
    let mealProvider: (UUID) -> PlannedMeal?
    let onUpdate: (PlannedMeal) -> Void
    let onRemove: (UUID) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var meal: PlannedMeal?
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                if let meal = meal {
                    ScrollView {
                        VStack(spacing: 24) {
                            recipeHeaderView(meal: meal)
                            statusSection(meal: meal)
                            notesSection
                            quickStatsView(meal: meal)
                            actionButtons(meal: meal)
                            
                            Button(action: {
                                guard var updatedMeal = self.meal else { return }
                                updatedMeal.notes = notes
                                onUpdate(updatedMeal)
                                dismiss()
                            }) {
                                Text("Save")
                                    .font(AppFonts.button(18))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                            .fill(AppColors.primaryYellow)
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.textSecondary)
                        Text("Meal not found")
                            .font(AppFonts.subtitle(20))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(AppColors.textPrimary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if meal != nil {
                    Button("Save") {
                        guard var updatedMeal = self.meal else { return }
                        updatedMeal.notes = notes
                        onUpdate(updatedMeal)
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .onAppear {
            meal = mealProvider(mealId)
            if let m = meal {
                notes = m.notes
            }
        }
    }
    
    private func recipeHeaderView(meal: PlannedMeal) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(meal.recipe.name)
                    .font(AppFonts.title(20))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(meal.category.rawValue)
                    .font(AppFonts.subtitle(14))
                    .foregroundColor(AppColors.textAccent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                    )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func statusSection(meal: PlannedMeal) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Meal Status")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(PlannedMeal.MealStatus.allCases, id: \.self) { status in
                    Button(action: {
                        var updated = meal
                        updated.status = status
                        self.meal = updated
                        onUpdate(updated)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: iconForStatus(status))
                                .font(.system(size: 20))
                                .foregroundColor(meal.status == status ? .black : AppColors.textPrimary)
                            
                            Text(status.rawValue)
                                .font(AppFonts.caption(12))
                                .foregroundColor(meal.status == status ? .black : AppColors.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(meal.status == status ? AppColors.primaryYellow : AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(meal.status == status ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notes & Feedback")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("How did it taste? Any modifications?")
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Add your notes here...", text: $notes, axis: .vertical)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                            )
                    )
                    .lineLimit(4...8)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func quickStatsView(meal: PlannedMeal) -> some View {
        HStack(spacing: 0) {
            statItem(icon: "clock", title: "Time", value: "\(meal.recipe.cookingTime)m")
            Divider().frame(height: 40).background(AppColors.cardBorder)
            statItem(icon: "flame", title: "Calories", value: "\(meal.recipe.calories)")
            Divider().frame(height: 40).background(AppColors.cardBorder)
            statItem(icon: "chart.bar", title: "Protein", value: "\(Int(meal.recipe.macros.protein))g")
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func actionButtons(meal: PlannedMeal) -> some View {
        VStack(spacing: 12) {
            Button {
                onRemove(mealId)
                dismiss()
            } label: {
                Text("Remove Meal")
                    .font(AppFonts.button(14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                            .fill(AppColors.secondaryPink)
                    )
            }
        }
    }
    
    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.subtitle(14))
                .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func iconForStatus(_ status: PlannedMeal.MealStatus) -> String {
        switch status {
        case .planned:
            return "clock"
        case .cooked:
            return "checkmark.circle"
        case .skipped:
            return "xmark.circle"
        }
    }
}

#Preview {
    MealDetailView(
        mealId: UUID(),
        mealProvider: { _ in nil },
        onUpdate: { _ in },
        onRemove: { _ in }
    )
}
