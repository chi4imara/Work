import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    @Binding var selectedTab: TabItem
    
    @State private var selectedTypes: Set<AccessoryType> = []
    @State private var selectedStatuses: Set<AccessoryStatus> = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Accessory Type")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            VStack(spacing: 12) {
                                ForEach(AccessoryType.allCases) { type in
                                    FilterCheckboxView(
                                        title: type.displayName,
                                        isSelected: selectedTypes.contains(type)
                                    ) {
                                        if selectedTypes.contains(type) {
                                            selectedTypes.remove(type)
                                        } else {
                                            selectedTypes.insert(type)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Status")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            VStack(spacing: 12) {
                                ForEach(AccessoryStatus.allCases) { status in
                                    FilterCheckboxView(
                                        title: status.displayName,
                                        isSelected: selectedStatuses.contains(status),
                                        statusColor: Color.statusColor(for: status)
                                    ) {
                                        if selectedStatuses.contains(status) {
                                            selectedStatuses.remove(status)
                                        } else {
                                            selectedStatuses.insert(status)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primaryWhite)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
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
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
            
            if viewModel.isFiltered {
                Text("Active")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.accentOrange)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func loadCurrentFilters() {
        selectedTypes = viewModel.selectedTypes
        selectedStatuses = viewModel.selectedStatuses
    }
    
    private func applyFilters() {
        viewModel.selectedTypes = selectedTypes
        viewModel.selectedStatuses = selectedStatuses
        viewModel.applyFilters()
        withAnimation {
            selectedTab = .catalog
        }
    }
    
    private func resetFilters() {
        selectedTypes.removeAll()
        selectedStatuses.removeAll()
        viewModel.clearFilters()
        withAnimation {
            selectedTab = .catalog
        }
    }
}

struct FilterCheckboxView: View {
    let title: String
    let isSelected: Bool
    var statusColor: Color?
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.primaryWhite.opacity(0.5), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(statusColor ?? AppColors.primaryBlue)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                    }
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite)
                
                Spacer()
                
                if let statusColor = statusColor {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? (statusColor ?? AppColors.primaryBlue) : AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(viewModel: AccessoryViewModel(), selectedTab: .constant(.filters))
}
