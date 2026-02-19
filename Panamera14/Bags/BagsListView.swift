import SwiftUI

struct BagsListView: View {
    @ObservedObject var bagStore: BagStore
    @State private var showingAddBag = false
    @State private var selectedBagId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("My Bags")
                            .font(.bellGothic(32, weight: .bold))
                            .foregroundColor(.appDarkBlue)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddBag = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.appDarkBlue)
                                .frame(width: 44, height: 44)
                                .background(Color.appAccentYellow)
                                .clipShape(Circle())
                                .shadow(color: Color.appAccentYellow.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                    
                    SearchBar(text: $bagStore.searchText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if bagStore.filteredBags.isEmpty {
                    EmptyBagsView(showingAddBag: $showingAddBag)
                } else {
                    BagsGridView(bags: bagStore.filteredBags, selectedBagId: $selectedBagId)
                }
            }
        }
        .sheet(isPresented: $showingAddBag) {
            AddEditBagView(bagStore: bagStore)
        }
        .sheet(item: Binding(
            get: { selectedBagId.map { BagIdWrapper(id: $0) } },
            set: { selectedBagId = $0?.id }
        )) { wrapper in
            BagDetailView(bagId: wrapper.id, bagStore: bagStore)
        }
    }
}

struct BagIdWrapper: Identifiable {
    let id: UUID
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.appPrimaryBlue)
            
            TextField("Search bags...", text: $text)
                .font(.bellGothic(16))
                .foregroundColor(.appTextDark)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct EmptyBagsView: View {
    @Binding var showingAddBag: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "bag")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("Your bag catalog is empty")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .multilineTextAlignment(.center)
                
                Text("Add your first bag to get started")
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddBag = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Bag")
                }
                .font(.bellGothic(18, weight: .bold))
                .foregroundColor(.appDarkBlue)
                .frame(width: 160, height: 50)
                .background(Color.appAccentYellow)
                .cornerRadius(25)
                .shadow(color: Color.appAccentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct BagsGridView: View {
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
                    BagCardView(bag: bag)
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

struct BagCardView: View {
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
                
                if bag.isFavorite {
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
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bag.name)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .lineLimit(1)
                
                Text(bag.size.displayName)
                    .font(.bellGothic(14))
                    .foregroundColor(.appPrimaryBlue)
                
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
    }
}
