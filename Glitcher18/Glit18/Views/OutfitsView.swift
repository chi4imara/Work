import SwiftUI

struct OutfitsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddOutfit = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Outfits")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddOutfit = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.accentYellow)
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if dataManager.outfits.isEmpty {
                    EmptyOutfitsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dataManager.outfits.sorted { $0.createdAt > $1.createdAt }) { outfit in
                                NavigationLink(destination: OutfitDetailView(outfitId: outfit.id)
                                    .environmentObject(dataManager)) {
                                    OutfitCard(outfit: outfit)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView()
        }
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    @EnvironmentObject var dataManager: DataManager
    
    private var accessoryCount: Int {
        dataManager.getAccessoriesForOutfit(outfit.id).count
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.deepPurple)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(outfit.name)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                if !outfit.description.isEmpty {
                    Text(outfit.description)
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
                
                Text("\(accessoryCount) accessory\(accessoryCount == 1 ? "" : "ies")")
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.secondaryText)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(16)
        .glassCard()
    }
}

struct EmptyOutfitsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            VStack(spacing: 12) {
                Text("No outfits yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create your first outfit to start organizing your accessories.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OutfitsView()
        .environmentObject(DataManager.shared)
}
