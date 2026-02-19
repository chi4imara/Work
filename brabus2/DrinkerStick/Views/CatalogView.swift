import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: DrinkViewModel
    @State private var showingAddDrink = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Catalog")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddDrink = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(ColorTheme.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if viewModel.drinks.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "wineglass")
                            .font(.system(size: 80))
                            .foregroundColor(ColorTheme.primaryPink.opacity(0.6))
                        
                        Text("Add your first drink to start the catalog")
                            .font(.playfair(20, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            showingAddDrink = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Drink")
                            }
                            .font(.playfair(18, weight: .semibold))
                            .foregroundColor(ColorTheme.buttonText)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(ColorTheme.buttonBackground)
                            .cornerRadius(25)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.drinks) { drink in
                                NavigationLink(destination: DrinkDetailView(drinkId: drink.id, viewModel: viewModel)) {
                                    DrinkCardView(drink: drink)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddDrink) {
            AddDrinkView(viewModel: viewModel)
        }
    }
}

struct DrinkCardView: View {
    let drink: Drink
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryPink.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: drinkTypeIcon(for: drink.type))
                    .font(.title2)
                    .foregroundColor(ColorTheme.primaryPink)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .lineLimit(1)
                
                Text(drink.type.displayName)
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                HStack {
                    Text(String(format: "%.1f%%", drink.strength))
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.accentBlue)
                    
                    Spacer()
                    
                    Text(drink.country)
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.textTertiary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ColorTheme.textTertiary)
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func drinkTypeIcon(for type: DrinkType) -> String {
        switch type {
        case .whiskey, .rum, .cognac, .brandy:
            return "wineglass"
        case .vodka, .gin, .tequila:
            return "drop"
        case .wine, .champagne:
            return "wineglass.fill"
        case .beer:
            return "mug"
        case .liqueur:
            return "drop.fill"
        case .other:
            return "questionmark"
        }
    }
}

#Preview {
    CatalogView(viewModel: DrinkViewModel())
}
