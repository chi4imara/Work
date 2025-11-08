import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: DreamListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Button("Reset") {
                        viewModel.resetFilters()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Filters")
                        .font(AppFonts.callout.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                .padding()
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Status") {
                            VStack(spacing: 12) {
                                ForEach(DreamStatus.allCases, id: \.self) { status in
                                    FilterCheckbox(
                                        title: status.displayName,
                                        isSelected: viewModel.selectedStatuses.contains(status),
                                        color: status.color
                                    ) {
                                        if viewModel.selectedStatuses.contains(status) {
                                            viewModel.selectedStatuses.remove(status)
                                        } else {
                                            viewModel.selectedStatuses.insert(status)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Date Range") {
                            VStack(spacing: 12) {
                                ForEach(DreamListViewModel.DateFilter.allCases, id: \.self) { filter in
                                    FilterRadioButton(
                                        title: filter.displayName,
                                        isSelected: viewModel.dateFilter == filter
                                    ) {
                                        viewModel.dateFilter = filter
                                    }
                                }
                                
                                if viewModel.dateFilter == .custom {
                                    VStack(spacing: 12) {
                                        DatePicker("From", selection: $viewModel.customStartDate, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        DatePicker("To", selection: $viewModel.customEndDate, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                        }
                        
                        FilterSection(title: "Deadline") {
                            VStack(spacing: 12) {
                                FilterCheckbox(
                                    title: "Filter by deadline",
                                    isSelected: viewModel.deadlineFilter != nil,
                                    color: AppColors.yellow
                                ) {
                                    if viewModel.deadlineFilter != nil {
                                        viewModel.deadlineFilter = nil
                                    } else {
                                        viewModel.deadlineFilter = Date()
                                    }
                                }
                                
                                if viewModel.deadlineFilter != nil {
                                    DatePicker("Deadline before", selection: Binding(
                                        get: { viewModel.deadlineFilter ?? Date() },
                                        set: { viewModel.deadlineFilter = $0 }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.top, 8)
                                }
                            }
                        }
                        
                        FilterSection(title: "Tags") {
                            VStack(spacing: 12) {
                                let availableTags = DataManager.shared.tags.map { $0.name }
                                
                                if availableTags.isEmpty {
                                    Text("No tags available")
                                        .font(AppFonts.regular(14))
                                        .foregroundColor(AppColors.secondaryText)
                                } else {
                                    ForEach(availableTags, id: \.self) { tag in
                                        FilterCheckbox(
                                            title: tag,
                                            isSelected: viewModel.selectedTags.contains(tag),
                                            color: AppColors.teal
                                        ) {
                                            if viewModel.selectedTags.contains(tag) {
                                                viewModel.selectedTags.remove(tag)
                                            } else {
                                                viewModel.selectedTags.insert(tag)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.semiBold(18))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct FilterCheckbox: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? color : AppColors.secondaryText)
                
                Text(title)
                    .font(AppFonts.regular(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterRadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.secondaryText)
                
                Text(title)
                    .font(AppFonts.regular(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(viewModel: DreamListViewModel())
}
