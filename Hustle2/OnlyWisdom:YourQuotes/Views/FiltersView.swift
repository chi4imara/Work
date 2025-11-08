import SwiftUI

struct FiltersView: View {
    @ObservedObject var quoteStore: QuoteStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedType: QuoteType?
    @State private var selectedCategories: Set<String> = []
    @State private var selectedPeriod: FilterPeriod = .all
    @State private var customStartDate: Date = Date()
    @State private var customEndDate: Date = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Gradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        filterSection(title: "Type") {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(QuoteType.allCases, id: \.self) { type in
                                    FilterButton(
                                        title: type.displayName,
                                        icon: type.icon,
                                        isSelected: selectedType == type
                                    ) {
                                        selectedType = selectedType == type ? nil : type
                                    }
                                }
                            }
                        }
                        
                        if !quoteStore.categories.isEmpty {
                            filterSection(title: "Categories") {
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    ForEach(quoteStore.categories, id: \.id) { category in
                                        FilterButton(
                                            title: category.name,
                                            icon: "folder",
                                            isSelected: selectedCategories.contains(category.name)
                                        ) {
                                            if selectedCategories.contains(category.name) {
                                                selectedCategories.remove(category.name)
                                            } else {
                                                selectedCategories.insert(category.name)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        filterSection(title: "Time Period") {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ForEach(FilterPeriod.allCases, id: \.self) { period in
                                    FilterButton(
                                        title: period.rawValue,
                                        icon: "calendar",
                                        isSelected: selectedPeriod == period
                                    ) {
                                        selectedPeriod = period
                                    }
                                }
                                
                                if selectedPeriod == .custom {
                                    VStack(spacing: DesignSystem.Spacing.md) {
                                        DatePicker("From", selection: $customStartDate, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                        
                                        DatePicker("To", selection: $customEndDate, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                    }
                                    .padding(DesignSystem.Spacing.md)
                                    .background(Color.white)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.bottom, DesignSystem.Spacing.xxl)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Reset") {
                    resetFilters()
                },
                trailing: Button("Apply") {
                    applyFilters()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(title)
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            content()
        }
    }
    
    private func loadCurrentFilters() {
        selectedType = quoteStore.selectedType
        selectedCategories = quoteStore.selectedCategories
        selectedPeriod = quoteStore.selectedPeriod
        customStartDate = quoteStore.customStartDate
        customEndDate = quoteStore.customEndDate
    }
    
    private func applyFilters() {
        quoteStore.selectedType = selectedType
        quoteStore.selectedCategories = selectedCategories
        quoteStore.selectedPeriod = selectedPeriod
        quoteStore.customStartDate = customStartDate
        quoteStore.customEndDate = customEndDate
    }
    
    private func resetFilters() {
        selectedType = nil
        selectedCategories.removeAll()
        selectedPeriod = .all
        customStartDate = Date()
        customEndDate = Date()
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.primaryBlue)
                
                Text(title)
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(DesignSystem.Spacing.md)
            .background(
                isSelected ? DesignSystem.Colors.primaryBlue : Color.white
            )
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(color: DesignSystem.Shadow.light, radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(quoteStore: QuoteStore())
}
