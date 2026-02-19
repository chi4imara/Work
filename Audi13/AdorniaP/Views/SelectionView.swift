import SwiftUI

struct SelectionView: View {
    @ObservedObject var combinationStore: CombinationStore
    @State private var selectedCategory: CombinationCategory?
    @State private var searchResults: [Combination] = []
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
                    Text("Selection")
                        .font(.bauhausBold(28))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if selectedCategory == nil {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            Text("Choose an occasion")
                                .font(.bauhausRegular(16))
                                .foregroundColor(Color.theme.secondaryText)
                                .padding(.top, 20)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                                ForEach(CombinationCategory.allCases, id: \.self) { category in
                                    CategoryCard(category: category) {
                                        selectedCategory = category
                                        searchCombinations(for: category)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120)
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                selectedCategory = nil
                                searchResults = []
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                            
                            Text(selectedCategory?.rawValue ?? "")
                                .font(.bauhausBold(20))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Text("\(searchResults.count) found")
                                .font(.bauhausRegular(14))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        if searchResults.isEmpty {
                            VStack(spacing: 30) {
                                Spacer()
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                
                                VStack(spacing: 12) {
                                    Text("No matching combinations found")
                                        .font(.bauhausBold(22))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Text("Add descriptions to your combinations to help with selection")
                                        .font(.bauhausRegular(16))
                                        .foregroundColor(Color.theme.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                
                                Spacer()
                            }
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(searchResults) { combination in
                                        CombinationCard(combination: combination, combinationStore: combinationStore) {
                                            selectedCombination = combination
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 120)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedCombination) { combination in
            CombinationDetailView(
                combinationId: combination.id,
                combinationStore: combinationStore
            )
        }
        .onChange(of: combinationStore.combinations) { _ in
            if let category = selectedCategory {
                searchCombinations(for: category)
            }
        }
    }
    
    private func searchCombinations(for category: CombinationCategory) {
        searchResults = combinationStore.searchCombinations(by: category)
    }
}

struct CategoryCard: View {
    let category: CombinationCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text(category.rawValue)
                    .font(.bauhausBold(16))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryIcon: String {
        switch category {
        case .everyday:
            return "sun.max"
        case .evening:
            return "moon.stars"
        case .special:
            return "star"
        case .work:
            return "briefcase"
        case .casual:
            return "figure.walk"
        case .formal:
            return "suit.heart"
        }
    }
}
