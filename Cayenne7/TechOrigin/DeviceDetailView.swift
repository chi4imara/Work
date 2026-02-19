import SwiftUI

struct DeviceDetailView: View {
    let device: Device
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(device.name)
                                    .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(device.category.displayName)
                                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.accentBlue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(AppColors.accentBlue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(AppColors.cardGradient)
                    .cornerRadius(16)
                    
                    VStack(spacing: 16) {
                        DetailSection(
                            title: "Purchase Date",
                            content: DateFormatter.longDate.string(from: device.purchaseDate),
                            icon: "calendar"
                        )
                        
                        DetailSection(
                            title: "Condition",
                            content: device.condition.rawValue,
                            icon: "checkmark.seal"
                        )
                        
                        if !device.specifications.isEmpty {
                            DetailSection(
                                title: "Technical Specifications",
                                content: device.specifications,
                                icon: "cpu",
                                isMultiline: true
                            )
                        }
                        
                        if !device.comment.isEmpty {
                            DetailSection(
                                title: "Comment",
                                content: device.comment,
                                icon: "text.bubble",
                                isMultiline: true
                            )
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.accentBlue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.buttonDanger)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditDeviceView(device: device, viewModel: viewModel)
        }
        .alert("Delete Device", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteDevice(device)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this device? This action cannot be undone.")
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.accentBlue)
                    .frame(width: 20)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(FontManager.playfairDisplay(size: 15, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(isMultiline ? nil : 1)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

#Preview {
    NavigationView {
        DeviceDetailView(
            device: Device(
                name: "iPhone 13 Pro",
                category: .phones,
                purchaseDate: Date(),
                specifications: "256 GB, Sierra Blue, 120Hz, 3 cameras",
                condition: .used,
                comment: "Main smartphone"
            ),
            viewModel: DeviceViewModel()
        )
    }
}
