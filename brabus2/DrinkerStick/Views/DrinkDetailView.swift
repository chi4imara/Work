import SwiftUI

struct DrinkDetailView: View {
    let drinkId: UUID
    @ObservedObject var viewModel: DrinkViewModel
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    private var drink: Drink? {
        viewModel.drinks.first { $0.id == drinkId }
    }
    
    var body: some View {
        Group {
            if let drink = drink {
                drinkDetailContent(drink: drink)
            } else {
                Text("Drink not found")
                    .font(.playfair(18, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
    }
    
    private func drinkDetailContent(drink: Drink) -> some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [ColorTheme.primaryPink.opacity(0.3), ColorTheme.accentPurple.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: drinkTypeIcon(for: drink.type))
                                .font(.system(size: 50))
                                .foregroundColor(ColorTheme.primaryPink)
                        }
                        
                        Text(drink.name)
                            .font(.playfair(28, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        InfoCard(title: "Type", value: drink.type.displayName, icon: "tag")
                        InfoCard(title: "Strength", value: String(format: "%.1f%%", drink.strength), icon: "thermometer")
                        InfoCard(title: "Country", value: drink.country, icon: "globe")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(ColorTheme.primaryYellow)
                            Text("Notes")
                                .font(.playfair(20, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        
                        if drink.notes.isEmpty {
                            Text("Add a note to save your impressions")
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.textTertiary)
                                .italic()
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(ColorTheme.cardBackground.opacity(0.5))
                                .cornerRadius(12)
                        } else {
                            Text(drink.notes)
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.textSecondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.playfair(18, weight: .semibold))
                            .foregroundColor(ColorTheme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.buttonBackground)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(.playfair(18, weight: .semibold))
                            .foregroundColor(ColorTheme.error)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.error.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditDrinkView(drink: drink, viewModel: viewModel)
        }
        .alert("Delete Drink", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteDrink(drink)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(drink.name)\"? This action cannot be undone.")
        }
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

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ColorTheme.accentBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(ColorTheme.textTertiary)
                
                Text(value)
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    NavigationView {
        DrinkDetailView(drinkId: Drink.sampleDrinks[0].id, viewModel: DrinkViewModel())
    }
}
