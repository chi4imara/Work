import SwiftUI

struct CategoryDevicesView: View {
    let category: DeviceCategory
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var categoryDevices: [Device] {
        viewModel.devices.filter { $0.category == category }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if categoryDevices.isEmpty {
                    emptyStateView
                } else {
                    devicesListView
                }
                
                Spacer(minLength: 80)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text(category.rawValue)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Color.clear
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var devicesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                categoryInfoView
                
                ForEach(categoryDevices) { device in
                    NavigationLink(destination: DeviceDetailView(deviceId: device.id, viewModel: viewModel)) {
                        DeviceCardView(device: device)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var categoryInfoView: some View {
        HStack(spacing: 16) {
            Image(systemName: categoryIcon)
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(ColorTheme.accentYellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(categoryDevices.count) device\(categoryDevices.count == 1 ? "" : "s")")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("in \(category.rawValue)")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                let totalImprovements = categoryDevices.reduce(0) { $0 + $1.improvements.count }
                if totalImprovements > 0 {
                    Text("\(totalImprovements) total improvement\(totalImprovements == 1 ? "" : "s")")
                        .font(.ubuntu(12))
                        .foregroundColor(ColorTheme.accentYellow)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .cardStyle()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: categoryIcon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No \(category.rawValue.lowercased()) devices")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add your first \(category.rawValue.lowercased()) device to get started")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
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
}

#Preview {
    NavigationView {
        CategoryDevicesView(category: .pc, viewModel: DeviceViewModel())
    }
}
