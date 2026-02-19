import SwiftUI

struct DevicesView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @State private var showingAddDevice = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Devices")
                            .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddDevice = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(AppColors.accentBlue)
                                .clipShape(Circle())
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterCategory.allCases) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: viewModel.selectedFilter == filter
                                ) {
                                    viewModel.selectedFilter = filter
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, -20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.filteredDevices.isEmpty {
                    EmptyStateView {
                        showingAddDevice = true
                    }
                } else {
                    DeviceListView(devices: viewModel.filteredDevices, viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $showingAddDevice) {
            AddDeviceView(viewModel: viewModel)
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
                .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.accentBlue : AppColors.secondaryBackground.opacity(0.5))
                )
        }
    }
}

struct EmptyStateView: View {
    let onAddDevice: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "laptopcomputer.and.iphone")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.accentBlue.opacity(0.6))
                
                VStack(spacing: 12) {
                    Text("Add your first device")
                        .font(FontManager.playfairDisplay(size: 24, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Start building your tech collection")
                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Button(action: onAddDevice) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Device")
                    }
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.accentBlue)
                    .cornerRadius(25)
                }
            }
            
            Spacer()
        }
    }
}

struct DeviceListView: View {
    let devices: [Device]
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(devices) { device in
                    NavigationLink(destination: DeviceDetailView(device: device, viewModel: viewModel)) {
                        DeviceCardView(device: device)
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

struct DeviceCardView: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(device.category.displayName)
                        .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.accentBlue)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Text("Purchased: \(device.purchaseDate, formatter: DateFormatter.shortDate)")
                .font(FontManager.playfairDisplay(size: 12, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    NavigationView {
        DevicesView(viewModel: DeviceViewModel())
    }
}
