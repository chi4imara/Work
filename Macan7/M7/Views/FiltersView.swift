import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempFilterOptions: FilterOptions
    @State private var showingDateRange = false
    
    init() {
        _tempFilterOptions = State(initialValue: FilterOptions())
    }
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        statusFilterSection
                        
                        categoryFilterSection
                        
                        locationFilterSection
                        
                        dateRangeFilterSection
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            tempFilterOptions = viewModel.filterOptions
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Spacer()
            
            if tempFilterOptions.isActive {
                Text("Active")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(.appYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.appYellow.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var statusFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            VStack(spacing: 12) {
                ForEach(ScenarioStatus.allCases, id: \.self) { status in
                    FilterToggleRow(
                        icon: status.icon,
                        title: status.rawValue,
                        isSelected: tempFilterOptions.selectedStatuses.contains(status),
                        color: status == .planned ? .appPlanned : .appCompleted
                    ) {
                        if tempFilterOptions.selectedStatuses.contains(status) {
                            tempFilterOptions.selectedStatuses.remove(status)
                        } else {
                            tempFilterOptions.selectedStatuses.insert(status)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var categoryFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            VStack(spacing: 12) {
                ForEach(ScenarioCategory.allCases, id: \.self) { category in
                    FilterToggleRow(
                        icon: category.icon,
                        title: category.rawValue,
                        isSelected: tempFilterOptions.selectedCategories.contains(category),
                        color: .appPrimary
                    ) {
                        if tempFilterOptions.selectedCategories.contains(category) {
                            tempFilterOptions.selectedCategories.remove(category)
                        } else {
                            tempFilterOptions.selectedCategories.insert(category)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var locationFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            TextField("Filter by location", text: $tempFilterOptions.locationFilter)
                .font(.ubuntu(16))
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appLightGray, lineWidth: 1)
                )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var dateRangeFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Date Range")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                if tempFilterOptions.dateRange != nil {
                    Button("Clear") {
                        tempFilterOptions.dateRange = nil
                    }
                    .font(.ubuntu(14))
                    .foregroundColor(.appPrimary)
                }
            }
            
            if let dateRange = tempFilterOptions.dateRange {
                VStack(spacing: 8) {
                    HStack {
                        Text("From:")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(.appSecondaryText)
                        
                        Spacer()
                        
                        Text(dateRange.lowerBound, style: .date)
                            .font(.ubuntu(14))
                            .foregroundColor(.appPrimaryText)
                    }
                    
                    HStack {
                        Text("To:")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(.appSecondaryText)
                        
                        Spacer()
                        
                        Text(dateRange.upperBound, style: .date)
                            .font(.ubuntu(14))
                            .foregroundColor(.appPrimaryText)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.appLightGray.opacity(0.5))
                )
            }
            
            Button(action: {
                showingDateRange = true
            }) {
                HStack {
                    Image(systemName: "calendar")
                    Text(tempFilterOptions.dateRange == nil ? "Select Date Range" : "Change Date Range")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appPrimary, lineWidth: 1)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .sheet(isPresented: $showingDateRange) {
            DateRangePickerView(dateRange: $tempFilterOptions.dateRange)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: applyFilters) {
                Text("Apply Filters")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appPrimary)
                    )
            }
            
            Button(action: resetFilters) {
                Text("Reset All")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appSecondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appLightGray, lineWidth: 1)
                    )
            }
        }
        .padding(.top, 20)
    }
    
    private func applyFilters() {
        viewModel.filterOptions = tempFilterOptions
        presentationMode.wrappedValue.dismiss()
    }
    
    private func resetFilters() {
        tempFilterOptions.reset()
        viewModel.resetFilters()
        presentationMode.wrappedValue.dismiss()
    }
}

struct FilterToggleRow: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? color : .appSecondaryText)
                    .frame(width: 20)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(isSelected ? .appPrimaryText : .appSecondaryText)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? color : .appLightGray)
            }
            .padding(.vertical, 8)
        }
    }
}

struct DateRangePickerView: View {
    @Binding var dateRange: ClosedRange<Date>?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Start Date")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                        
                        HStack {
                            Text("End Date")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Button {
                        let range = min(startDate, endDate)...max(startDate, endDate)
                        dateRange = range
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Set Range")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.appPrimary)
                            )
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
            .padding(.top, 20)
            .navigationTitle("Select Date Range")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            if let range = dateRange {
                startDate = range.lowerBound
                endDate = range.upperBound
            }
        }
    }
}

#Preview {
    NavigationView {
        FiltersView()
            .environmentObject(PhotoshootViewModel())
    }
}
