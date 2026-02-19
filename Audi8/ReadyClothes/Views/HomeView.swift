import SwiftUI

struct HomeView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    @State private var showingAddOutfit = false
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Outfits")
                            .font(.lumierepolis(28, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Total outfits: \(outfitViewModel.totalOutfitsCount)")
                            .font(.lumierepolis(16, weight: .light))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = .add
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if outfitViewModel.outfits.isEmpty {
                    EmptyStateView {
                        withAnimation {
                            selectedTab = .add
                        }
                    }
                    
                    Spacer()
                } else {
                    OutfitGridView(outfits: outfitViewModel.outfits)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "tshirt")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("No saved outfits yet")
                        .font(.lumierepolis(22, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Create ready-made sets of clothing, shoes and accessories")
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                        Text("Add first outfit")
                            .font(.lumierepolis(18, weight: .bold))
                    }
                    .foregroundColor(.textDark)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.primaryYellow)
                    )
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct OutfitGridView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    let outfits: [Outfit]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(outfits) { outfit in
                    NavigationLink(destination: OutfitDetailView(outfitId: outfit.id)
                        .environmentObject(outfitViewModel)) {
                        OutfitCardView(outfit: outfit)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 120)
        }
    }
}

struct OutfitCardView: View {
    let outfit: Outfit
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cardBackground)
                    .frame(width: 120, height: 120)
                
                if let image = outfit.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(15)
                } else {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary.opacity(0.3))
                }
                
                if outfit.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.accentPink)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                        )
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(outfit.name)
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                
                if !outfit.description.isEmpty {
                    Text(outfit.description)
                        .font(.lumierepolis(14, weight: .light))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                
                Text(outfit.category.displayName)
                    .font(.lumierepolis(12, weight: .light))
                    .foregroundColor(.primaryYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primaryYellow.opacity(0.2))
                    )
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground.opacity(0.3))
                .shadow(color: .shadowColor, radius: 5, x: 0, y: 2)
        )
    }
}
