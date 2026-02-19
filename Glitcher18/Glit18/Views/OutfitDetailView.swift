import SwiftUI

struct OutfitDetailView: View {
    let outfitId: UUID
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    private var outfit: Outfit? {
        dataManager.outfits.first { $0.id == outfitId }
    }
    
    private var matchingAccessories: [Accessory] {
        guard let outfit = outfit else { return [] }
        return dataManager.getAccessoriesForOutfit(outfit.id)
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
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
                                    
                                    Image(systemName: "tshirt.fill")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(AppColors.deepPurple)
                                }
                                
                                VStack(spacing: 8) {
                                    Text(outfit.name)
                                        .font(.playfairDisplay(size: 24, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Created \(outfit.createdAt.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.playfairDisplay(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .glassCard()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Description")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(outfit.description.isEmpty ? "No description available" : outfit.description)
                                    .font(.playfairDisplay(size: 16, weight: .regular))
                                    .foregroundColor(outfit.description.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .glassCard()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Matching Accessories")
                                        .font(.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Text("\(matchingAccessories.count)")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.accentYellow)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(AppColors.cardBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                if matchingAccessories.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text("No matching accessories yet")
                                            .font(.playfairDisplay(size: 16, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text("Add accessories and link them to this outfit from the Accessories tab.")
                                            .font(.playfairDisplay(size: 14, weight: .regular))
                                            .foregroundColor(AppColors.secondaryText)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                } else {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 12) {
                                        ForEach(matchingAccessories) { accessory in
                                            NavigationLink(destination: AccessoryDetailView(accessoryId: accessory.id)
                                                .environmentObject(dataManager)) {
                                                    AccessoryMiniCard(accessory: accessory)
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
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete Outfit")
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
                .navigationTitle(outfit.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        dataManager.deleteOutfit(outfit)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this outfit? This will also remove it from all linked accessories.")
                }
            } else {
                ZStack {
                    AppColors.primaryGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Outfit not found")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .navigationTitle("Outfit")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AccessoryMiniCard: View {
    let accessory: Accessory
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon(for: accessory.category))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.deepPurple)
            }
            
            VStack(spacing: 2) {
                Text(accessory.name)
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(accessory.category)
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
