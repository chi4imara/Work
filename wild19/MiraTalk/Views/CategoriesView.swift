import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempSelectedCategories: Set<QuestionCategory>
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        self._tempSelectedCategories = State(initialValue: viewModel.selectedCategories)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Choose Categories")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Select the types of questions you'd like to see")
                            .font(.playfairDisplay(size: 16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(QuestionCategory.allCases, id: \.self) { category in
                                CategoryRow(
                                    category: category,
                                    isSelected: tempSelectedCategories.contains(category)
                                ) {
                                    toggleCategory(category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
                    
                    VStack(spacing: 16) {
                        Button(action: applySelection) {
                            Text("Apply Selection")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    tempSelectedCategories.isEmpty ?
                                    AnyShapeStyle(AppColors.darkGray.opacity(0.3)) :
                                        AnyShapeStyle(LinearGradient(
                                        colors: [AppColors.primaryBlue, AppColors.blueGradientEnd],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                )
                                .cornerRadius(28)
                                .shadow(
                                    color: tempSelectedCategories.isEmpty ? .clear : AppColors.primaryBlue.opacity(0.3),
                                    radius: 8, x: 0, y: 4
                                )
                        }
                        .disabled(tempSelectedCategories.isEmpty)
                        
                        Button(action: resetSelection) {
                            Text("Select All")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Select Categories", isPresented: .constant(tempSelectedCategories.isEmpty && viewModel.selectedCategories.isEmpty)) {
            Button("OK") { }
        } message: {
            Text("Please select at least one category to continue.")
        }
    }
    
    private func toggleCategory(_ category: QuestionCategory) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if tempSelectedCategories.contains(category) {
                tempSelectedCategories.remove(category)
            } else {
                tempSelectedCategories.insert(category)
            }
        }
    }
    
    private func resetSelection() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            tempSelectedCategories = Set(QuestionCategory.allCases)
        }
    }
    
    private func applySelection() {
        guard !tempSelectedCategories.isEmpty else {
            return
        }
        
        viewModel.selectedCategories = tempSelectedCategories
        viewModel.applyCategories()
        dismiss()
    }
}

struct CategoryRow: View {
    let category: QuestionCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isSelected ? AppColors.primaryBlue.opacity(0.1) : AppColors.lightGray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(categoryDescription(for: category))
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.primaryBlue : AppColors.lightGray)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ?
                        AppColors.primaryBlue.opacity(0.05) :
                        AppColors.primaryWhite.opacity(0.8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? AppColors.primaryBlue.opacity(0.3) : AppColors.lightGray,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private func categoryDescription(for category: QuestionCategory) -> String {
        switch category {
        case .introduction:
            return "Questions to get to know someone"
        case .company:
            return "Fun questions for groups and parties"
        case .personal:
            return "Deep, meaningful conversation starters"
        case .funny:
            return "Light-hearted and humorous questions"
        case .philosophical:
            return "Thought-provoking and deep questions"
        case .forKids:
            return "Age-appropriate questions for children"
        }
    }
}

#Preview {
    CategoriesView(viewModel: AppViewModel())
}
