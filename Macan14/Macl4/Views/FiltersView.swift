import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSelectedCategories: Set<StoreCategory>
    @State private var tempSelectedTypes: Set<StoreType>
    @State private var tempSelectedPriceLevels: Set<PriceLevel>
    
    init(viewModel: StoreViewModel) {
        self.viewModel = viewModel
        self._tempSelectedCategories = State(initialValue: viewModel.selectedCategories)
        self._tempSelectedTypes = State(initialValue: viewModel.selectedTypes)
        self._tempSelectedPriceLevels = State(initialValue: viewModel.selectedPriceLevels)
    }
    
    private var hasActiveFilters: Bool {
        !tempSelectedCategories.isEmpty || !tempSelectedTypes.isEmpty || !tempSelectedPriceLevels.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Filters")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(.appText)
                            
                            Text("Customize your store search")
                                .font(.ubuntu(16))
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 24) {
                            FilterSectionView(title: "Categories", icon: "folder.fill") {
                                FilterChipGrid(
                                    items: StoreCategory.allCases,
                                    selectedItems: $tempSelectedCategories,
                                    displayName: { $0.displayName },
                                    color: .appPrimary
                                )
                            }
                            
                            FilterSectionView(title: "Store Types", icon: "storefront") {
                                FilterChipGrid(
                                    items: StoreType.allCases,
                                    selectedItems: $tempSelectedTypes,
                                    displayName: { $0.displayName },
                                    color: .appAccent
                                )
                            }
                            
                            FilterSectionView(title: "Price Levels", icon: "dollarsign.circle.fill") {
                                FilterChipGrid(
                                    items: PriceLevel.allCases,
                                    selectedItems: $tempSelectedPriceLevels,
                                    displayName: { $0.displayName },
                                    color: .appSuccess
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        hasActiveFilters ?
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.appShadow, radius: hasActiveFilters ? 10 : 5, x: 0, y: 5)
                            }
                            
                            if hasActiveFilters {
                                Button(action: clearFilters) {
                                    Text("Clear All Filters")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(.appError)
                                }
                            }
                            
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func applyFilters() {
        viewModel.selectedCategories = tempSelectedCategories
        viewModel.selectedTypes = tempSelectedTypes
        viewModel.selectedPriceLevels = tempSelectedPriceLevels
        viewModel.applyFilters()
        dismiss()
    }
    
    private func clearFilters() {
        tempSelectedCategories.removeAll()
        tempSelectedTypes.removeAll()
        tempSelectedPriceLevels.removeAll()
    }
}

struct FilterSectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appPrimary)
                
                Text(title)
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(.appText)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
    }
}

struct FilterChipGrid<T: Hashable>: View {
    let items: [T]
    @Binding var selectedItems: Set<T>
    let displayName: (T) -> String
    let color: Color
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(items, id: \.self) { item in
                FilterChipView(
                    title: displayName(item),
                    isSelected: selectedItems.contains(item),
                    color: color
                ) {
                    if selectedItems.contains(item) {
                        selectedItems.remove(item)
                    } else {
                        selectedItems.insert(item)
                    }
                }
            }
        }
    }
}

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected ? color : Color.clear
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color, lineWidth: isSelected ? 0 : 2)
                )
                .cornerRadius(20)
                .shadow(color: Color.appShadow, radius: isSelected ? 5 : 2, x: 0, y: isSelected ? 3 : 1)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(viewModel: StoreViewModel())
}
