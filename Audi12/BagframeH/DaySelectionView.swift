import SwiftUI

struct DaySelectionView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @State private var selectedScenario: DayScenario?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Day Selection")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if selectedScenario == nil {
                    ScenarioSelectionView(selectedScenario: $selectedScenario)
                } else {
                    BagRecommendationsView(
                        scenario: selectedScenario!,
                        selectedScenario: $selectedScenario
                    )
                }
            }
        }
    }
}

struct ScenarioSelectionView: View {
    @Binding var selectedScenario: DayScenario?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Choose your day scenario")
                    .font(.bellGothic(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(DayScenario.allCases, id: \.self) { scenario in
                        ScenarioCard(scenario: scenario) {
                            selectedScenario = scenario
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ScenarioCard: View {
    let scenario: DayScenario
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: scenario.icon)
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.yellow)
                
                Text(scenario.rawValue)
                    .font(.bellGothic(size: 16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BagRecommendationsView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let scenario: DayScenario
    @Binding var selectedScenario: DayScenario?
    
    var recommendedBags: [Bag] {
        bagViewModel.getBagsForScenario(scenario)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    selectedScenario = nil
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(AppColors.yellow)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: scenario.icon)
                        .font(.title)
                        .foregroundColor(AppColors.yellow)
                    
                    Text(scenario.rawValue)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            if recommendedBags.isEmpty {
                EmptyRecommendationsView()
                
                Spacer()
            } else {
                RecommendedBagsListView(bags: recommendedBags)
            }
        }
    }
}

struct EmptyRecommendationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No suitable bags found")
                    .font(.bellGothic(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add day descriptions to your bag cards to get recommendations")
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct RecommendedBagsListView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bags: [Bag]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id).environmentObject(bagViewModel)) {
                        RecommendedBagCard(bag: bag)
                            .environmentObject(bagViewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct RecommendedBagCard: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bag: Bag
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: bag.type.icon)
                .font(.title)
                .foregroundColor(AppColors.yellow)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bag.name.isEmpty ? "Unnamed Bag" : bag.name)
                    .font(.bellGothic(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(bag.type.displayName)
                    .font(.bellGothic(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                
                if !bag.description.isEmpty {
                    Text(bag.description)
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
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
                
                VStack {
                    Text("\(bag.items.count)")
                        .font(.bellGothic(size: 16, weight: .bold))
                        .foregroundColor(AppColors.yellow)
                    
                    Text("items")
                        .font(.bellGothic(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
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
    DaySelectionView()
        .environmentObject(BagViewModel())
}
