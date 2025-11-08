import SwiftUI

struct FiltersView: View {
    @ObservedObject var store: VictoryStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempFilterPeriod: FilterPeriod
    @State private var tempFilterCategory: String?
    @State private var tempSearchText: String
    @State private var tempCustomStartDate: Date?
    @State private var tempCustomEndDate: Date?
    @State private var showingStartDatePicker = false
    @State private var showingEndDatePicker = false
    
    init(store: VictoryStore) {
        self.store = store
        self._tempFilterPeriod = State(initialValue: store.filterPeriod)
        self._tempFilterCategory = State(initialValue: store.filterCategory)
        self._tempSearchText = State(initialValue: store.searchText)
        self._tempCustomStartDate = State(initialValue: store.customDateRange.start)
        self._tempCustomEndDate = State(initialValue: store.customDateRange.end)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Period")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(spacing: 8) {
                                ForEach(FilterPeriod.allCases, id: \.self) { period in
                                    FilterOptionRow(
                                        title: period.rawValue,
                                        isSelected: tempFilterPeriod == period
                                    ) {
                                        tempFilterPeriod = period
                                    }
                                }
                            }
                        }
                        
                        if tempFilterPeriod == .custom {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Date Range")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        showingStartDatePicker = true
                                    } label: {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("From")
                                                .font(AppFonts.caption1)
                                                .foregroundColor(AppColors.textSecondary)
                                            
                                            Text(tempCustomStartDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select")
                                                .font(AppFonts.callout)
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                    
                                    Button {
                                        showingEndDatePicker = true
                                    } label: {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("To")
                                                .font(AppFonts.caption1)
                                                .foregroundColor(AppColors.textSecondary)
                                            
                                            Text(tempCustomEndDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select")
                                                .font(AppFonts.callout)
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(spacing: 8) {
                                FilterOptionRow(
                                    title: "All",
                                    isSelected: tempFilterCategory == nil
                                ) {
                                    tempFilterCategory = nil
                                }
                                
                                ForEach(store.categories, id: \.id) { category in
                                    FilterOptionRow(
                                        title: category.name,
                                        isSelected: tempFilterCategory == category.name
                                    ) {
                                        tempFilterCategory = category.name
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Search")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Search in titles and notes", text: $tempSearchText)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        tempFilterPeriod = .all
                        tempFilterCategory = nil
                        tempSearchText = ""
                        tempCustomStartDate = nil
                        tempCustomEndDate = nil
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        store.filterPeriod = tempFilterPeriod
                        store.filterCategory = tempFilterCategory
                        store.searchText = tempSearchText
                        store.customDateRange = (tempCustomStartDate, tempCustomEndDate)
                        store.applyFilters()
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .sheet(isPresented: $showingStartDatePicker) {
            DatePickerView(
                title: "Start Date",
                selectedDate: Binding(
                    get: { tempCustomStartDate ?? Date() },
                    set: { tempCustomStartDate = $0 }
                )
            )
        }
        .sheet(isPresented: $showingEndDatePicker) {
            DatePickerView(
                title: "End Date",
                selectedDate: Binding(
                    get: { tempCustomEndDate ?? Date() },
                    set: { tempCustomEndDate = $0 }
                )
            )
        }
    }
}

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            .padding(12)
            .background(isSelected ? AppColors.buttonSecondary : AppColors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DatePickerView: View {
    let title: String
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
    }
}

#Preview {
    FiltersView(store: VictoryStore())
}
