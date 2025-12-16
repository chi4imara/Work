import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategories: Set<UUID>
    @Binding var selectedStatus: Gift.GiftStatus?
    @Binding var isPresented: Bool
    
    @State private var tempSelectedCategories: Set<UUID> = []
    @State private var tempSelectedStatus: Gift.GiftStatus? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Categories")
                            .font(.appHeadline(20))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(dataManager.categories) { category in
                                CategoryFilterItem(
                                    category: category,
                                    isSelected: tempSelectedCategories.contains(category.id)
                                ) {
                                    if tempSelectedCategories.contains(category.id) {
                                        tempSelectedCategories.remove(category.id)
                                    } else {
                                        tempSelectedCategories.insert(category.id)
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Status")
                            .font(.appHeadline(20))
                            .foregroundColor(AppColors.primaryText)
                        
                        VStack(spacing: 12) {
                            StatusFilterItem(
                                title: "All",
                                isSelected: tempSelectedStatus == nil
                            ) {
                                tempSelectedStatus = nil
                            }
                            
                            ForEach(Gift.GiftStatus.allCases, id: \.self) { status in
                                StatusFilterItem(
                                    title: status.displayName,
                                    isSelected: tempSelectedStatus == status
                                ) {
                                    tempSelectedStatus = status
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        tempSelectedCategories.removeAll()
                        tempSelectedStatus = nil
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        selectedCategories = tempSelectedCategories
                        selectedStatus = tempSelectedStatus
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            tempSelectedCategories = selectedCategories
            tempSelectedStatus = selectedStatus
        }
    }
}

struct CategoryFilterItem: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                    .font(.system(size: 16))
                
                Text(category.name)
                    .font(.appBody(14))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(AppColors.primaryBlue)
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .padding(12)
            .background(isSelected ? AppColors.primaryText : AppColors.cardBackground.opacity(0.7))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? AppColors.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusFilterItem: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(isSelected ? AppColors.primaryBlue : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(AppColors.primaryText, lineWidth: 2)
                    )
                    .overlay(
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 8, height: 8)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                Text(title)
                    .font(.appBody(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
