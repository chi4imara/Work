import SwiftUI

struct FilterView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCultures: Set<String> = []
    @State private var selectedWorkTypes: Set<WorkType> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        culturesSection
                    
                        workTypesSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        selectedCultures.removeAll()
                        selectedWorkTypes.removeAll()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomButtons
            }
        }
        .onAppear {
            selectedCultures = taskManager.selectedCultures
            selectedWorkTypes = taskManager.selectedWorkTypes
        }
    }
    
    private var culturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cultures")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            if taskManager.availableCultures().isEmpty {
                Text("No cultures available")
                    .font(.appBody)
                    .foregroundColor(.appMediumGray)
                    .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(taskManager.availableCultures(), id: \.self) { culture in
                            FilterChip(
                                title: culture,
                                isSelected: selectedCultures.contains(culture)
                            ) {
                                toggleCultureSelection(culture)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
    }
    
    private var workTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Work Types")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(WorkType.allCases, id: \.self) { workType in
                        FilterChip(
                            title: workType.rawValue,
                            icon: workType.icon,
                            isSelected: selectedWorkTypes.contains(workType)
                        ) {
                            toggleWorkTypeSelection(workType)
                        }
                    }
                }
            }
        }
    }
    
    private var bottomButtons: some View {
        VStack(spacing: 12) {
            Button(action: applyFilters) {
                Text("Apply Filters")
                    .font(.appHeadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .cornerRadius(25)
            }
            
            if hasActiveFilters {
                Button(action: clearAllFilters) {
                    Text("Clear All Filters")
                        .font(.appCallout)
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
    }

    private var hasActiveFilters: Bool {
        !selectedCultures.isEmpty || !selectedWorkTypes.isEmpty
    }
    
    private func toggleCultureSelection(_ culture: String) {
        if selectedCultures.contains(culture) {
            selectedCultures.remove(culture)
        } else {
            selectedCultures.insert(culture)
        }
    }
    
    private func toggleWorkTypeSelection(_ workType: WorkType) {
        if selectedWorkTypes.contains(workType) {
            selectedWorkTypes.remove(workType)
        } else {
            selectedWorkTypes.insert(workType)
        }
    }
    
    private func applyFilters() {
        taskManager.selectedCultures = selectedCultures
        taskManager.selectedWorkTypes = selectedWorkTypes
        dismiss()
    }
    
    private func clearAllFilters() {
        selectedCultures.removeAll()
        selectedWorkTypes.removeAll()
        taskManager.clearFilters()
        dismiss()
    }
}

struct FilterChip: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.appCaption1)
                }
                
                Text(title)
                    .font(.appCallout)
                    .lineLimit(1)
            }
            .foregroundColor(isSelected ? .white : .appDarkGray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.primary : AppColors.lightGray)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? AppColors.primary : AppColors.mediumGray, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environmentObject(TaskManager())
    }
}
