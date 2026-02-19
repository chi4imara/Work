import SwiftUI

struct FavoritesView: View {
    @ObservedObject var bagStore: BagStore
    @State private var selectedBagId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.bellGothic(32, weight: .bold))
                        .foregroundColor(.appDarkBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if bagStore.favoriteBags.isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoriteBagsGridView(bags: bagStore.favoriteBags, selectedBagId: $selectedBagId)
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedBagId.map { BagIdWrapper(id: $0) } },
            set: { selectedBagId = $0?.id }
        )) { wrapper in
            BagDetailView(bagId: wrapper.id, bagStore: bagStore)
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No favorite bags yet")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .multilineTextAlignment(.center)
                
                Text("Mark bags as favorites to see them here")
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FavoriteBagsGridView: View {
    let bags: [Bag]
    @Binding var selectedBagId: UUID?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(bags) { bag in
                    FavoriteBagCardView(bag: bag)
                        .onTapGesture {
                            selectedBagId = bag.id
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
    }
}

struct FavoriteBagCardView: View {
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .frame(height: 120)
                
                if let image = bag.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "bag")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.appPrimaryBlue.opacity(0.6))
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(bag.name)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .lineLimit(1)
                
                HStack {
                    Text(bag.size.displayName)
                        .font(.bellGothic(12))
                        .foregroundColor(.appPrimaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appPrimaryBlue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text(bag.style.displayName)
                        .font(.bellGothic(12))
                        .foregroundColor(.appAccentYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appAccentYellow.opacity(0.2))
                        .cornerRadius(8)
                    
                    Spacer()
                }
                
                Text(bag.suitableFor)
                    .font(.bellGothic(12))
                    .foregroundColor(.appTextDark)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.red.opacity(0.2), lineWidth: 2)
        )
    }
}
