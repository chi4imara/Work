import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: NailIdeasViewModel
    @Binding var selectedTab: Int
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempColorFilter: String
    @State private var tempDesignType: DesignType?
    @State private var tempSeasonEvent: SeasonEvent?
    @State private var tempSelectedStatus: Set<IdeaStatus>
    
    init(viewModel: NailIdeasViewModel, selectedTab: Binding<Int>) {
        self.viewModel = viewModel
        _tempColorFilter = State(initialValue: viewModel.selectedColorFilter)
        _tempDesignType = State(initialValue: viewModel.selectedDesignType)
        _tempSeasonEvent = State(initialValue: viewModel.selectedSeasonEvent)
        _tempSelectedStatus = State(initialValue: viewModel.selectedStatus)
        
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Color")
                                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter color name", text: $tempColorFilter)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Design Type")
                                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                Button(action: {
                                    tempDesignType = nil
                                }) {
                                    HStack {
                                        Text("All Design Types")
                                            .font(FontManager.playfairDisplay(size: 16))
                                        Spacer()
                                        if tempDesignType == nil {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(AppColors.accentYellow)
                                        }
                                    }
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(tempDesignType == nil ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(tempDesignType == nil ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                                
                                ForEach(DesignType.allCases, id: \.self) { type in
                                    Button(action: {
                                        tempDesignType = type
                                    }) {
                                        HStack {
                                            Text(type.rawValue)
                                                .font(FontManager.playfairDisplay(size: 16))
                                            Spacer()
                                            if tempDesignType == type {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(AppColors.accentYellow)
                                            }
                                        }
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(tempDesignType == type ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(tempDesignType == type ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Season / Event")
                                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                Button(action: {
                                    tempSeasonEvent = nil
                                }) {
                                    HStack {
                                        Text("All Seasons / Events")
                                            .font(FontManager.playfairDisplay(size: 16))
                                        Spacer()
                                        if tempSeasonEvent == nil {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(AppColors.accentYellow)
                                        }
                                    }
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(tempSeasonEvent == nil ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(tempSeasonEvent == nil ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                                
                                ForEach(SeasonEvent.allCases, id: \.self) { event in
                                    Button(action: {
                                        tempSeasonEvent = event
                                    }) {
                                        HStack {
                                            Text(event.rawValue)
                                                .font(FontManager.playfairDisplay(size: 16))
                                            Spacer()
                                            if tempSeasonEvent == event {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(AppColors.accentYellow)
                                            }
                                        }
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(tempSeasonEvent == event ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(tempSeasonEvent == event ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Filter by Status")
                                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(IdeaStatus.allCases, id: \.self) { status in
                                    Button(action: {
                                        if tempSelectedStatus.contains(status) {
                                            tempSelectedStatus.remove(status)
                                        } else {
                                            tempSelectedStatus.insert(status)
                                        }
                                    }) {
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: status.icon)
                                                    .font(.system(size: 16))
                                                Text(status.rawValue)
                                                    .font(FontManager.playfairDisplay(size: 16))
                                            }
                                            Spacer()
                                            if tempSelectedStatus.contains(status) {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(AppColors.accentYellow)
                                            }
                                        }
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(tempSelectedStatus.contains(status) ? AppColors.accentYellow.opacity(0.1) : AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(tempSelectedStatus.contains(status) ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.accentYellow)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset All Filters")
                                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func applyFilters() {
        viewModel.selectedColorFilter = tempColorFilter
        viewModel.selectedDesignType = tempDesignType
        viewModel.selectedSeasonEvent = tempSeasonEvent
        viewModel.selectedStatus = tempSelectedStatus
        viewModel.updateFilteredIdeas()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func resetFilters() {
        tempColorFilter = ""
        tempDesignType = nil
        tempSeasonEvent = nil
        tempSelectedStatus = Set(IdeaStatus.allCases)
        
        viewModel.resetFilters()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}
