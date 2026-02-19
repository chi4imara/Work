import SwiftUI

struct CombinationsView: View {
    @ObservedObject var combinationStore: CombinationStore
    @State private var showingAddCombination = false
    @State private var selectedCombination: Combination?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Combinations")
                        .font(.bauhausBold(28))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if combinationStore.combinations.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                        
                        VStack(spacing: 12) {
                            Text("No combinations yet")
                                .font(.bauhausBold(22))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("Add your first successful jewelry combination")
                                .font(.bauhausRegular(16))
                                .foregroundColor(Color.theme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: {
                            showingAddCombination = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Add Combination")
                                    .font(.bauhausBold(16))
                            }
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.buttonBackground)
                            .cornerRadius(25)
                            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(combinationStore.combinations) { combination in
                                CombinationCard(combination: combination, combinationStore: combinationStore) {
                                    selectedCombination = combination
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
            
            if !combinationStore.combinations.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddCombination = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.theme.buttonText)
                                .frame(width: 56, height: 56)
                                .background(Color.theme.buttonBackground)
                                .clipShape(Circle())
                                .shadow(color: Color.theme.cardShadow, radius: 10, x: 0, y: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCombination) {
            AddCombinationView(combinationStore: combinationStore)
        }
        .sheet(item: $selectedCombination) { combination in
            CombinationDetailView(
                combinationId: combination.id,
                combinationStore: combinationStore
            )
        }
    }
}

struct CombinationCard: View {
    let combination: Combination
    @ObservedObject var combinationStore: CombinationStore
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(combination.name.isEmpty ? "Untitled Combination" : combination.name)
                            .font(.bauhausBold(18))
                            .foregroundColor(Color.theme.primaryText)
                            .lineLimit(1)
                        
                        Text(combination.shortDescription)
                            .font(.bauhausRegular(14))
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(combination.jewelryCount)")
                            .font(.bauhausBold(20))
                            .foregroundColor(Color.theme.primaryBlue)
                        
                        Text("items")
                            .font(.bauhausRegular(12))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                
                if !combination.jewelries.isEmpty {
                    Text(combination.jewelryList)
                        .font(.bauhausRegular(12))
                        .foregroundColor(Color.theme.accentOrange)
                        .lineLimit(1)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
            .overlay(
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            combinationStore.toggleFavorite(combinationId: combination.id)
                        }) {
                            Image(systemName: combinationStore.isFavorite(combinationId: combination.id) ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(combinationStore.isFavorite(combinationId: combination.id) ? Color.red : Color.theme.secondaryText)
                                .padding(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
