import SwiftUI

struct AccessoryDetailView: View {
    let accessoryId: UUID
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var accessory: Accessory? {
        dataManager.accessories.first { $0.id == accessoryId }
    }
    
    private var relatedOutfits: [Outfit] {
        guard let accessory = accessory else { return [] }
        return dataManager.outfits.filter { accessory.outfitIds.contains($0.id) }
    }
    
    var body: some View {
        Group {
            if let accessory = accessory {
                ZStack {
                    AppColors.primaryGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.accentGradient)
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: categoryIcon(for: accessory.category))
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(AppColors.deepPurple)
                                }
                                
                                VStack(spacing: 8) {
                                    Text(accessory.name)
                                        .font(.playfairDisplay(size: 24, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(accessory.category)
                                        .font(.playfairDisplay(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.accentYellow)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .glassCard()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Description")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(accessory.description.isEmpty ? "No description available" : accessory.description)
                                    .font(.playfairDisplay(size: 16, weight: .regular))
                                    .foregroundColor(accessory.description.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .glassCard()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Fits with Outfits")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                if relatedOutfits.isEmpty {
                                    Text("Not linked to any outfit")
                                        .font(.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    LazyVStack(spacing: 8) {
                                        ForEach(relatedOutfits) { outfit in
                                            NavigationLink(destination: OutfitDetailView(outfitId: outfit.id)
                                                .environmentObject(dataManager)) {
                                                    OutfitRowView(outfit: outfit)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            .padding()
                            .glassCard()
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Edit")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .primaryButton()
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        LinearGradient(
                                            colors: [AppColors.errorRed, AppColors.errorRed.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 50)
                        }
                        .padding()
                    }
                }
                .navigationTitle(accessory.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .sheet(isPresented: $showingEditView) {
                    EditAccessoryView(accessory: accessory)
                }
                .alert("Delete Accessory", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        dataManager.deleteAccessory(accessory)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this accessory? This action cannot be undone.")
                }
            } else {
                ZStack {
                    AppColors.primaryGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Accessory not found")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .navigationTitle("Accessory")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "earrings":
            return "ear"
        case "rings":
            return "circle"
        case "bracelets":
            return "oval"
        case "necklaces":
            return "link"
        case "watches":
            return "clock"
        default:
            return "sparkles"
        }
    }
}

struct OutfitRowView: View {
    let outfit: Outfit
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "tshirt.fill")
                .foregroundColor(AppColors.accentYellow)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(outfit.name)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !outfit.description.isEmpty {
                    Text(outfit.description)
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.secondaryText)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationView {
        AccessoryDetailView(
            accessoryId: UUID()
        )
    }
    .environmentObject(DataManager.shared)
}
