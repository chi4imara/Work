import SwiftUI

struct FiltersView: View {
    @Binding var selectedFilters: Set<TaskStatus>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Filter Tasks")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Choose which task statuses to display")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        FilterOption(
                            title: "All Tasks",
                            description: "Show all tasks regardless of status",
                            isSelected: selectedFilters.count == TaskStatus.allCases.count,
                            color: AppColors.primaryBlue
                        ) {
                            if selectedFilters.count == TaskStatus.allCases.count {
                                selectedFilters.removeAll()
                            } else {
                                selectedFilters = Set(TaskStatus.allCases)
                            }
                        }
                        
                        Divider()
                            .background(AppColors.lightBlue)
                        
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            FilterOption(
                                title: status.displayName,
                                description: statusDescription(for: status),
                                isSelected: selectedFilters.contains(status),
                                color: Color.statusColor(for: status)
                            ) {
                                if selectedFilters.contains(status) {
                                    selectedFilters.remove(status)
                                } else {
                                    selectedFilters.insert(status)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Apply Filters")
                            .font(AppFonts.buttonText)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.darkBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
    
    private func statusDescription(for status: TaskStatus) -> String {
        switch status {
        case .inProgress:
            return "Tasks that are currently being worked on"
        case .completed:
            return "Tasks that have been finished"
        case .overdue:
            return "Tasks that have passed their deadline"
        }
    }
}

struct FilterOption: View {
    let title: String
    let description: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(color, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.cardTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(description)
                        .font(AppFonts.cardSubtitle)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color.opacity(0.1) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? color.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(selectedFilters: .constant(Set(TaskStatus.allCases)))
}
