import SwiftUI

struct FiltersView: View {
    @ObservedObject var store: FirstExperienceStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeriod: FilterPeriod
    @State private var selectedCategory: String
    @State private var searchText: String
    @State private var customDateFrom: Date
    @State private var customDateTo: Date
    
    init(store: FirstExperienceStore) {
        self.store = store
        self._selectedPeriod = State(initialValue: store.selectedPeriod)
        self._selectedCategory = State(initialValue: store.selectedCategory)
        self._searchText = State(initialValue: store.searchText)
        self._customDateFrom = State(initialValue: store.customDateFrom)
        self._customDateTo = State(initialValue: store.customDateTo)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            periodFilterSection
                            
                            if selectedPeriod == .custom {
                                customDateSection
                            }
                            
                            categoryFilterSection
                            
                            searchFilterSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(FontManager.callout)
                .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Text("Filters")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Button("Apply") {
                    applyFilters()
                }
                .font(FontManager.callout)
                .foregroundColor(AppColors.accentYellow)
            }
            
            Divider()
                .background(AppColors.pureWhite.opacity(0.3))
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var periodFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Time Period")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                ForEach(FilterPeriod.allCases, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                    }) {
                        HStack {
                            Text(period.rawValue)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.pureWhite)
                            
                            Spacer()
                            
                            if selectedPeriod == period {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.accentYellow)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.pureWhite.opacity(selectedPeriod == period ? 0.2 : 0.1))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                                }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.top, 8)
    }
    
    private var customDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date Range")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                DatePicker("From", selection: $customDateFrom, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .colorScheme(.dark)
                
                DatePicker("To", selection: $customDateTo, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .colorScheme(.dark)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.pureWhite.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)

                        .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                    }
            )
        }
    }
    
    private var categoryFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                Button(action: {
                    selectedCategory = "All"
                }) {
                    HStack {
                        Text("All Categories")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.pureWhite)
                        
                        Spacer()
                        
                        if selectedCategory == "All" {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.accentYellow)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.pureWhite.opacity(selectedCategory == "All" ? 0.2 : 0.1))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)

                                .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                            }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                ForEach(store.categories.sorted(by: { $0.name < $1.name }), id: \.id) { category in
                    Button(action: {
                        selectedCategory = category.name
                    }) {
                        HStack {
                            Text(category.name)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.pureWhite)
                            
                            Spacer()
                            
                            if selectedCategory == category.name {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.accentYellow)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.pureWhite.opacity(selectedCategory == category.name ? 0.2 : 0.1))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)

                                    .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                                }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var searchFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            TextField("Search in titles and notes...", text: $searchText)
                .font(FontManager.body)
                .foregroundColor(AppColors.pureWhite)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)

                            .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                        }
                )
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.pureWhite.opacity(0.6))
                            }
                            .padding(.trailing, 16)
                        }
                    }
                )
        }
    }
    
    private func applyFilters() {
        store.selectedPeriod = selectedPeriod
        store.selectedCategory = selectedCategory
        store.searchText = searchText
        store.customDateFrom = customDateFrom
        store.customDateTo = customDateTo
        
        store.applyFilters()
        dismiss()
    }
}

#Preview {
    FiltersView(store: FirstExperienceStore())
}
