import SwiftUI

struct MyTechView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @State private var showingAddDevice = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredDevices.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    deviceListView
                }
            }
        }
        .sheet(isPresented: $showingAddDevice) {
            AddDeviceView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Tech")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddDevice = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorTheme.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.secondaryText)
                
                TextField("Search devices...", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .cardStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: viewModel.selectedCategory == nil
                    ) {
                        viewModel.selectedCategory = nil
                    }
                    
                    ForEach(DeviceCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category == viewModel.selectedCategory ? nil : category
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var deviceListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredDevices) { device in
                    DeviceCardRow(device: device, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "desktopcomputer")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No devices found")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(viewModel.devices.isEmpty ? "Add your first device to get started" : "Try adjusting your search or filters")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddDevice = true
            }) {
                Text("Add Device")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 160, height: 48)
                    .background(ColorTheme.accentYellow)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct DeviceCardRow: View {
    let device: Device
    @ObservedObject var viewModel: DeviceViewModel
    @State private var showingDeleteAlert = false
    @State private var showingEditDevice = false
    
    var body: some View {
        NavigationLink(destination: DeviceDetailView(deviceId: device.id, viewModel: viewModel)) {
            DeviceCardView(device: device)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                showingEditDevice = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(ColorTheme.accentYellow)
        }
        .sheet(isPresented: $showingEditDevice) {
            AddDeviceView(viewModel: viewModel, deviceId: device.id)
        }
        .alert("Delete Device", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteDevice(device)
            }
        } message: {
            Text("Are you sure you want to delete \"\(device.name)\"? This will also delete all associated improvements. This action cannot be undone.")
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
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("\(device.category.rawValue) / \(device.subcategory)")
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.accentYellow)
            }
            
            if !device.description.isEmpty {
                Text(device.description)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 12))
                    .foregroundColor(ColorTheme.accentYellow)
                
                Text(device.improvementsSummary)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.accentYellow)
                
                Spacer()
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryPink : ColorTheme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    MyTechView(viewModel: DeviceViewModel())
}
