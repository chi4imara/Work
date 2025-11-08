import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RepairInstructionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempSelectedCategories: Set<RepairCategory>
    
    init(viewModel: RepairInstructionViewModel) {
        self.viewModel = viewModel
        self._tempSelectedCategories = State(initialValue: viewModel.selectedCategories)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filter by Categories")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(RepairCategory.allCases, id: \.self) { category in
                                CategoryFilterRow(
                                    category: category,
                                    isSelected: tempSelectedCategories.contains(category),
                                    instructionCount: viewModel.instructionsByCategory(category).count
                                ) {
                                    toggleCategory(category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            viewModel.selectedCategories = tempSelectedCategories
                            viewModel.updateFilteredInstructions()
                            dismiss()
                        } label: {
                            Text("Apply Filters")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.primaryBlue)
                                .cornerRadius(12)
                            
                        }
                        
                        Button {
                            tempSelectedCategories = Set(RepairCategory.allCases)
                        } label: {
                            Text("Reset All")
                                .font(.headline)
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .padding(.top, -35)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Filters")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    private func toggleCategory(_ category: RepairCategory) {
        if tempSelectedCategories.contains(category) {
            tempSelectedCategories.remove(category)
        } else {
            tempSelectedCategories.insert(category)
        }
    }
}

struct CategoryFilterRow: View {
    let category: RepairCategory
    let isSelected: Bool
    let instructionCount: Int
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: category.icon)
                        .font(.title2)
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(instructionCount) instruction\(instructionCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(isSelected ? .primaryBlue : .textSecondary)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.cardShadow, radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryColor: Color {
        switch category.icon {
        case "drop.fill": return Color.primaryBlue
        case "bolt.fill": return Color.accentOrange
        case "chair.fill": return Color.accentGreen
        case "paintbrush.fill": return Color.accentRed
        case "leaf.fill": return Color.accentGreen
        default: return Color.textSecondary
        }
    }
}

#Preview {
    FilterView(viewModel: RepairInstructionViewModel())
}

