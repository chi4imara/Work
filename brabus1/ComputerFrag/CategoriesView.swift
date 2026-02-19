import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.devices.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    categoriesListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(DeviceCategory.allCases, id: \.self) { category in
                    NavigationLink(destination: CategoryDevicesView(category: category, viewModel: viewModel)) {
                        CategoryCardView(category: category, deviceCount: viewModel.deviceCount(for: category))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No categories yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add devices to see them organized by categories")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCardView: View {
    let category: DeviceCategory
    let deviceCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: categoryIcon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(ColorTheme.accentYellow)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(ColorTheme.accentYellow.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(deviceCountText)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(subcategoriesPreview)
                    .font(.ubuntu(12))
                    .foregroundColor(ColorTheme.secondaryText.opacity(0.8))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.accentYellow)
                
                Spacer()
            }
        }
        .padding(20)
        .cardStyle()
        .opacity(deviceCount > 0 ? 1.0 : 0.6)
    }
    
    private var categoryIcon: String {
        switch category {
        case .pc:
            return "desktopcomputer"
        case .console:
            return "gamecontroller"
        case .peripherals:
            return "keyboard"
        case .accessories:
            return "cable.connector"
        }
    }
    
    private var deviceCountText: String {
        if deviceCount == 0 {
            return "No devices"
        } else if deviceCount == 1 {
            return "1 device"
        } else {
            return "\(deviceCount) devices"
        }
    }
    
    private var subcategoriesPreview: String {
        let subcategories = category.subcategories
        if subcategories.count <= 3 {
            return subcategories.joined(separator: ", ")
        } else {
            return subcategories.prefix(3).joined(separator: ", ") + "..."
        }
    }
}

#Preview {
    CategoriesView(viewModel: DeviceViewModel())
}
