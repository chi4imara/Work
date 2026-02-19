import SwiftUI

struct DeviceDetailView: View {
    let deviceId: UUID
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddImprovement = false
    @State private var showingDeleteAlert = false
    @State private var showingEditDevice = false
    
    private var currentDevice: Device? {
        viewModel.getDevice(by: deviceId)
    }
    
    private var device: Device {
        currentDevice ?? Device(name: "", category: .pc, subcategory: "", description: "")
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        deviceInfoView
                        
                        improvementsSection
                        
                        deleteButton
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddImprovement) {
            AddImprovementView(deviceId: deviceId, viewModel: viewModel)
        }
        .sheet(isPresented: $showingEditDevice) {
            AddDeviceView(viewModel: viewModel, deviceId: deviceId)
        }
        .alert("Delete Device", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let device = currentDevice {
                    viewModel.deleteDevice(device)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            if let device = currentDevice {
                Text("Are you sure you want to delete \"\(device.name)\"? This will also delete all \(device.improvements.count) associated improvement\(device.improvements.count == 1 ? "" : "s"). This action cannot be undone.")
            }
        }
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
            
            Text(deviceName)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    showingEditDevice = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.accentYellow)
                }
                
                Button(action: {
                    showingAddImprovement = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.accentYellow)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var deviceName: String {
        currentDevice?.name ?? ""
    }
    
    private var deviceInfoView: some View {
        Group {
            if let device = currentDevice {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: categoryIcon(for: device))
                            .font(.system(size: 24))
                            .foregroundColor(ColorTheme.accentYellow)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(device.category.rawValue)
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text(device.subcategory)
                                .font(.ubuntu(14))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        Spacer()
                    }
                    
                    if !device.description.isEmpty {
                        Text(device.description)
                            .font(.ubuntu(16))
                            .foregroundColor(ColorTheme.primaryText)
                            .lineSpacing(4)
                    }
                }
                .padding(20)
                .cardStyle()
            }
        }
    }
    
    private var improvementsSection: some View {
        Group {
            if let device = currentDevice {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Improvements")
                            .font(.ubuntu(22, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddImprovement = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Add")
                                    .font(.ubuntu(14, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(ColorTheme.accentYellow)
                            .cornerRadius(8)
                        }
                    }
                    
                    if device.improvements.isEmpty {
                        emptyImprovementsView
                    } else {
                        improvementsList(device: device)
                    }
                }
            }
        }
    }
    
    private var emptyImprovementsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.accentYellow.opacity(0.6))
            
            Text("No planned improvements")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Button(action: {
                showingAddImprovement = true
            }) {
                Text("Add First Improvement")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(ColorTheme.accentYellow)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .cardStyle()
    }
    
    private func improvementsList(device: Device) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(device.improvements) { improvement in
                NavigationLink(destination: EditImprovementView(improvementId: improvement.id, viewModel: viewModel)) {
                    ImprovementRowView(improvement: improvement)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var deleteButton: some View {
        Group {
            if currentDevice != nil {
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Delete Device")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(ColorTheme.error)
                    .cornerRadius(12)
                }
                .padding(.top, 20)
            }
        }
    }
    
    private func categoryIcon(for device: Device) -> String {
        switch device.category {
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
        DeviceDetailView(deviceId: UUID(), viewModel: DeviceViewModel())
    }
}

struct ImprovementRowView: View {
    let improvement: Improvement
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(improvement.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                if !improvement.description.isEmpty {
                    Text(improvement.description)
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
                
                Text(improvement.status.rawValue)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(statusColor)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(16)
        .cardStyle()
    }
    
    private var statusColor: Color {
        switch improvement.status {
        case .planned:
            return ColorTheme.warning
        case .completed:
            return ColorTheme.success
        }
    }
}
