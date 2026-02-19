import SwiftUI

struct StorageLocationsView: View {
    @ObservedObject var viewModel: ToolViewModel
    @State private var selectedLocation: String?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.storageLocations.isEmpty {
                    emptyStateView
                } else {
                    locationsListView
                }
            }
        }
        .sheet(item: Binding<StorageLocationWrapper?>(
            get: { selectedLocation.map(StorageLocationWrapper.init) },
            set: { selectedLocation = $0?.location }
        )) { wrapper in
            ToolsByLocationView(location: wrapper.location, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Storage Locations")
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "location")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            VStack(spacing: 12) {
                Text("No Storage Locations")
                    .font(FontManager.headline(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Storage locations will appear automatically after adding tools with storage information")
                    .font(FontManager.body(.regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Text("Add First Tool")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 140, height: 44)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(22)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var locationsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.storageLocations, id: \.location) { locationInfo in
                    StorageLocationCard(
                        location: locationInfo.location,
                        count: locationInfo.count
                    ) {
                        selectedLocation = locationInfo.location
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct StorageLocationCard: View {
    let location: String
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.accentOrange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: locationIcon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(ColorTheme.accentOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location)
                        .font(FontManager.body(.medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(2)
                    
                    Text("\(count) tool\(count == 1 ? "" : "s")")
                        .font(FontManager.caption(.regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.mutedText)
            }
            .padding(20)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var locationIcon: String {
        let lowercased = location.lowercased()
        
        if lowercased.contains("garage") {
            return "door.garage.closed"
        } else if lowercased.contains("workshop") || lowercased.contains("shop") {
            return "hammer"
        } else if lowercased.contains("toolbox") || lowercased.contains("box") {
            return "shippingbox"
        } else if lowercased.contains("case") || lowercased.contains("kit") {
            return "case"
        } else if lowercased.contains("drawer") {
            return "cabinet"
        } else if lowercased.contains("shelf") {
            return "books.vertical"
        } else if lowercased.contains("basement") || lowercased.contains("cellar") {
            return "house"
        } else {
            return "location"
        }
    }
}

struct ToolsByLocationView: View {
    let location: String
    @ObservedObject var viewModel: ToolViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var toolsAtLocation: [Tool] {
        viewModel.toolsInStorageLocation(location)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.body(.regular))
                        .foregroundColor(ColorTheme.accentOrange)
                        .opacity(0)
                        .disabled(true)
                        
                        Spacer()
                        
                        Text(location)
                            .font(FontManager.headline(.medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.body(.regular))
                        .foregroundColor(ColorTheme.accentOrange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    
                    if toolsAtLocation.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "location")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(ColorTheme.mutedText)
                            
                            Text("No tools found at this location")
                                .font(FontManager.body(.regular))
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(toolsAtLocation) { tool in
                                    ToolCardView(tool: tool) {
                                        viewModel.selectedToolId = tool.id
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StorageLocationWrapper: Identifiable {
    let id = UUID()
    let location: String
}
