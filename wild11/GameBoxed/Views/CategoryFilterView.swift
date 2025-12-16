import SwiftUI

struct CategoryFilterView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempSelectedCategories: Set<String> = []
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Filter by Category")
                        .font(FontManager.ubuntu(size: 20, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryBlue)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.categories, id: \.name) { category in
                            CategoryFilterRow(
                                category: category,
                                isSelected: tempSelectedCategories.contains(category.name)
                            ) {
                                if tempSelectedCategories.contains(category.name) {
                                    tempSelectedCategories.remove(category.name)
                                } else {
                                    tempSelectedCategories.insert(category.name)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                HStack(spacing: 16) {
                    Button {
                        tempSelectedCategories.removeAll()
                    } label: {
                        Text("Clear All")
                            .font(FontManager.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorManager.primaryBlue, lineWidth: 1)
                            )
                    }
                    
                    Button {
                        viewModel.selectedCategories = tempSelectedCategories
                        dismiss()
                    } label: {
                        Text("Apply")
                            .font(FontManager.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorManager.primaryBlue)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            tempSelectedCategories = viewModel.selectedCategories
        }
    }
}

struct CategoryFilterRow: View {
    let category: Category
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("\(category.gameCount) games")
                        .font(FontManager.ubuntu(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? ColorManager.primaryBlue : ColorManager.secondaryText)
                    .font(.title2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorManager.primaryBlue : Color.clear, lineWidth: 2)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoryFilterView(viewModel: GameViewModel())
}
