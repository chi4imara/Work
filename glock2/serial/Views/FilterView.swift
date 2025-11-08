import SwiftUI

struct FilterView: View {
    @Binding var selectedCategoryFilter: SeriesCategory?
    @Binding var selectedCustomCategoryFilter: CustomCategory?
    @ObservedObject var viewModel: SeriesViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.primaryBlue)
                    
                    Spacer()
                    
                    Text("Filter Series")
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button("Clear All") {
                        selectedCategoryFilter = nil
                        selectedCustomCategoryFilter = nil
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.accentRed)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(SeriesCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                    FilterOption(
                                        title: category.displayName,
                                        icon: categoryIcon(for: category),
                                        isSelected: selectedCategoryFilter == category,
                                        onTap: {
                                            if selectedCategoryFilter == category {
                                                selectedCategoryFilter = nil
                                            } else {
                                                selectedCategoryFilter = category
                                                selectedCustomCategoryFilter = nil
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        
                        if !viewModel.customCategories.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Custom Categories")
                                    .font(.titleSmall)
                                    .foregroundColor(.textPrimary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(viewModel.customCategories, id: \.id) { customCategory in
                                        FilterOption(
                                            title: customCategory.name,
                                            icon: customCategory.icon,
                                            isSelected: selectedCustomCategoryFilter?.id == customCategory.id,
                                            onTap: {
                                                if selectedCustomCategoryFilter?.id == customCategory.id {
                                                    selectedCustomCategoryFilter = nil
                                                } else {
                                                    selectedCustomCategoryFilter = customCategory
                                                    selectedCategoryFilter = nil
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            }
            VStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func categoryIcon(for category: SeriesCategory) -> String {
        switch category {
        case .drama:
            return "theatermasks"
        case .comedy:
            return "face.smiling"
        case .sciFi:
            return "sparkles"
        case .other:
            return "tv"
        case .custom:
            return "folder"
        }
    }
}

struct FilterOption: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryBlue : Color.lightBlue.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .white : .textSecondary)
                }
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(isSelected ? .primaryBlue : .textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryBlue.opacity(0.1) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.primaryBlue : Color.lightBlue, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

