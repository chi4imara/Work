import SwiftUI

struct CharacteristicsView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @State private var selectedCategory: DeviceCategory?
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    if selectedCategory != nil {
                        Button(action: {
                            selectedCategory = nil
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.accentBlue)
                        }
                    }
                    
                    Text(selectedCategory?.displayName ?? "Characteristics")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if let category = selectedCategory {
                    CategoryDevicesView(
                        category: category,
                        devices: viewModel.devicesByCategory[category] ?? [],
                        viewModel: viewModel
                    )
                } else {
                    CategoriesOverviewView(
                        categoryCounts: viewModel.categoryCounts,
                        onCategorySelected: { category in
                            selectedCategory = category
                        }
                    )
                }
            }
        }
    }
}

struct CategoriesOverviewView: View {
    let categoryCounts: [DeviceCategory: Int]
    let onCategorySelected: (DeviceCategory) -> Void
    
    var body: some View {
        if categoryCounts.isEmpty {
            EmptyCharacteristicsView()
            
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(DeviceCategory.allCases, id: \.self) { category in
                        let count = categoryCounts[category] ?? 0
                        if count > 0 {
                            CategoryCard(
                                category: category,
                                count: count,
                                onTap: {
                                    onCategorySelected(category)
                                }
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

struct CategoryCard: View {
    let category: DeviceCategory
    let count: Int
    let onTap: () -> Void
    
    private var categoryColor: Color {
        switch category {
        case .phones:
            return AppColors.accentBlue
        case .computers:
            return AppColors.accentPurple
        case .electronics:
            return AppColors.accentOrange
        case .tools:
            return AppColors.accentGreen
        case .other:
            return AppColors.secondaryText
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .phones:
            return "iphone"
        case .computers:
            return "laptopcomputer"
        case .electronics:
            return "tv"
        case .tools:
            return "hammer"
        case .other:
            return "questionmark.circle"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(count) device\(count == 1 ? "" : "s")")
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryDevicesView: View {
    let category: DeviceCategory
    let devices: [Device]
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(devices) { device in
                    NavigationLink(destination: DeviceDetailView(device: device, viewModel: viewModel)) {
                        CharacteristicDeviceCard(device: device)
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

struct CharacteristicDeviceCard: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    if !device.firstSpecificationLine.isEmpty {
                        Text(device.firstSpecificationLine)
                            .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct EmptyCharacteristicsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No data for characteristics")
                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some devices to see characteristics")
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        CharacteristicsView(viewModel: DeviceViewModel())
    }
}
