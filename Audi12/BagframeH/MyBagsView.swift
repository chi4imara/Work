import SwiftUI

struct MyBagsView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @State private var showingAddBag = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("My Bags")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddBag = true
                    }) {
                        Image(systemName: "plus")
                            .font(.bellGothic(size: 20, weight: .bold))
                            .foregroundColor(AppColors.yellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if bagViewModel.bags.isEmpty {
                    EmptyBagsView(showingAddBag: $showingAddBag)
                    
                    Spacer()
                } else {
                    BagsListView()
                }
            }
        }
        .sheet(isPresented: $showingAddBag) {
            AddEditBagView()
                .environmentObject(bagViewModel)
        }
    }
}

struct EmptyBagsView: View {
    @Binding var showingAddBag: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "handbag")
                .font(.system(size: 80))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No bags here yet")
                    .font(.bellGothic(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first bag to start organizing")
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddBag = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Bag")
                }
                .font(.bellGothic(size: 18, weight: .bold))
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(AppColors.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct BagsListView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bagViewModel.bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id).environmentObject(bagViewModel)) {
                        BagCardView(bag: bag)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct BagCardView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: bag.type.icon)
                    .font(.title2)
                    .foregroundColor(AppColors.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name.isEmpty ? "Unnamed Bag" : bag.name)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(bag.type.displayName)
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        bagViewModel.toggleFavorite(bagId: bag.id)
                    }) {
                        Image(systemName: bagViewModel.isFavorite(bagId: bag.id) ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(bagViewModel.isFavorite(bagId: bag.id) ? AppColors.error : AppColors.secondaryText)
                    }
                    
                    Text("\(bag.items.count)")
                        .font(.bellGothic(size: 16, weight: .bold))
                        .foregroundColor(AppColors.yellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.yellow.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            if !bag.description.isEmpty {
                Text(bag.description)
                    .font(.bellGothic(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    MyBagsView()
        .environmentObject(BagViewModel())
}
