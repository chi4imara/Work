import SwiftUI

struct GarageView: View {
    @ObservedObject var viewModel: GarageViewModel
    @State private var showingAddItem = false
    @Binding var selectedTab: Int
    
    var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Garage")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                selectedTab = 2
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterType.allCases, id: \.rawValue) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: viewModel.selectedFilter == filter,
                                    action: {
                                        withAnimation(.easeInOut) {
                                            viewModel.selectedFilter = filter
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, -20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.filteredItems.isEmpty {
                    EmptyStateView(
                        icon: "wrench.and.screwdriver",
                        title: "Add your first item",
                        subtitle: "Start organizing your garage by adding tools, car care products, and spare parts.",
                        buttonTitle: "Add Item",
                        action: {
                            withAnimation {
                                selectedTab = 2
                            }
                        }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                                    ItemRowView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.white : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.lightBlue : AppColors.cardBackground)
                )
        }
    }
}

struct ItemRowView: View {
    let item: GarageItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: categoryIcon(for: item.category))
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
                .frame(width: 50, height: 50)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .lineLimit(1)
                
                Text(item.category.displayName)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(item.location)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .carCare: return "drop"
        case .spareParts: return "gearshape"
        case .other: return "cube.box"
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text(subtitle)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
