import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: BagViewModel
    @State private var showingAddBag = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("My Bags")
                        .font(.bellGothicBold(size: 32))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddBag = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(width: 40, height: 40)
                            .background(Color.theme.accentYellow)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                if viewModel.bags.isEmpty {
                    EmptyBagsView(showingAddBag: $showingAddBag)
                } else {
                    BagsListView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $showingAddBag) {
            AddBagView(viewModel: viewModel)
        }
    }
}

struct EmptyBagsView: View {
    @Binding var showingAddBag: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "bag")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textGray)
            
            VStack(spacing: 15) {
                Text("No bags added yet")
                    .font(.bellGothicBold(size: 24))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("Add bags and assign them usage scenarios")
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddBag = true
            }) {
                Text("Add First Bag")
                    .font(.bellGothicBold(size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct BagsListView: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Total bags: \(viewModel.bags.count)")
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.bags) { bag in
                        NavigationLink(destination: BagDetailView(bagId: bag.id, viewModel: viewModel)) {
                            BagCardView(bag: bag)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 120)
            }
        }
    }
}

struct BagCardView: View {
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name)
                        .font(.bellGothicBold(size: 18))
                        .foregroundColor(Color.theme.textWhite)
                    
                    HStack {
                        Image(systemName: bag.scenario.icon)
                            .font(.system(size: 12))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Text(bag.scenario.displayName)
                            .font(.bellGothicRegular(size: 14))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                }
                
                Spacer()
                
                if bag.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.errorRed)
                }
            }
            
            if !bag.comment.isEmpty {
                Text(bag.comment)
                    .font(.bellGothicRegular(size: 14))
                    .foregroundColor(Color.theme.textGray)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color.theme.cardGradient)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HomeView(viewModel: BagViewModel())
}
