import SwiftUI

struct FilterView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempSelectedCategories: Set<PurchaseCategory>
    @State private var tempSearchText: String
    @State private var tempSortOption: SortOption
    
    init() {
        _tempSelectedCategories = State(initialValue: Set(PurchaseCategory.allCases))
        _tempSearchText = State(initialValue: "")
        _tempSortOption = State(initialValue: .dateNewest)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.primaryYellow)
                        .disabled(true)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text("Filters & Sort")
                            .font(.bodyLarge)
                            .foregroundColor(.primaryWhite)
                        
                        Spacer()
                        
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.primaryYellow)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Search by name")
                            .font(.bodyLarge)
                            .foregroundColor(.primaryWhite)
                        
                        TextField("Enter purchase name", text: $tempSearchText)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.bodyLarge)
                            .foregroundColor(.primaryWhite)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(PurchaseCategory.allCases, id: \.self) { category in
                                CategoryFilterButton(
                                    category: category,
                                    isSelected: tempSelectedCategories.contains(category)
                                ) {
                                    if tempSelectedCategories.contains(category) {
                                        tempSelectedCategories.remove(category)
                                    } else {
                                        tempSelectedCategories.insert(category)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sort by")
                            .font(.bodyLarge)
                            .foregroundColor(.primaryWhite)
                        
                        VStack(spacing: 8) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                SortOptionButton(
                                    option: option,
                                    isSelected: tempSortOption == option
                                ) {
                                    tempSortOption = option
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button("Reset") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                tempSelectedCategories = Set(PurchaseCategory.allCases)
                                tempSearchText = ""
                                tempSortOption = .dateNewest
                                
                                purchaseStore.filterSettings.selectedCategories = tempSelectedCategories
                                purchaseStore.filterSettings.searchText = tempSearchText
                                purchaseStore.filterSettings.sortOption = tempSortOption
                                
                                purchaseStore.objectWillChange.send()
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button("Apply") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                purchaseStore.filterSettings.selectedCategories = tempSelectedCategories
                                purchaseStore.filterSettings.searchText = tempSearchText
                                purchaseStore.filterSettings.sortOption = tempSortOption
                                
                                purchaseStore.objectWillChange.send()
                            }
                            dismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(20)
            }
        }
        .onAppear {
            tempSelectedCategories = purchaseStore.filterSettings.selectedCategories
            tempSearchText = purchaseStore.filterSettings.searchText
            tempSortOption = purchaseStore.filterSettings.sortOption
        }
    }
}

struct CategoryFilterButton: View {
    let category: PurchaseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .primaryYellow : .primaryWhite.opacity(0.7))
                
                Text(category.rawValue)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite)
                
                Spacer()
            }
            .padding(12)
            .background(Color.cardBackground.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct SortOptionButton: View {
    let option: SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .primaryYellow : .primaryWhite.opacity(0.7))
                
                Text(option.rawValue)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite)
                
                Spacer()
            }
            .padding(12)
            .background(Color.cardBackground.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.cardBackground)
            .cornerRadius(8)
            .font(.bodyMedium)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bodyLarge)
            .foregroundColor(.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primaryYellow)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bodyLarge)
            .foregroundColor(.primaryWhite)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.cardBackground.opacity(0.3))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    FilterView()
        .environmentObject(PurchaseStore())
}
