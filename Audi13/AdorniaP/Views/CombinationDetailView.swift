import SwiftUI

struct CombinationDetailView: View {
    let combinationId: UUID
    @ObservedObject var combinationStore: CombinationStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditCombination = false
    @State private var showingAddJewelry = false
    @State private var showingDeleteAlert = false
    
    private var combination: Combination? {
        combinationStore.getCombination(by: combinationId)
    }
    
    var body: some View {
        Group {
            if let combination = combination {
                NavigationView {
                    ZStack {
                        LinearGradient(
                            colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        AnimatedBackground()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 12) {
                                    Text(combination.name.isEmpty ? "Untitled Combination" : combination.name)
                                        .font(.bauhausBold(24))
                                        .foregroundColor(Color.theme.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    if !combination.description.isEmpty {
                                        Text(combination.description)
                                            .font(.bauhausRegular(16))
                                            .foregroundColor(Color.theme.secondaryText)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.top, 20)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Jewelry Items")
                                            .font(.bauhausBold(20))
                                            .foregroundColor(Color.theme.primaryText)
                                        
                                        Spacer()
                                        
                                        Text("\(combination.jewelries.count) items")
                                            .font(.bauhausRegular(14))
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    
                                    if combination.jewelries.isEmpty {
                                        VStack(spacing: 16) {
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 40, weight: .light))
                                                .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                            
                                            VStack(spacing: 8) {
                                                Text("No jewelry in this combination yet")
                                                    .font(.bauhausBold(16))
                                                    .foregroundColor(Color.theme.primaryText)
                                                
                                                Text("Add jewelry items to complete your set")
                                                    .font(.bauhausRegular(14))
                                                    .foregroundColor(Color.theme.secondaryText)
                                                    .multilineTextAlignment(.center)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 40)
                                        .background(Color.theme.cardBackground)
                                        .cornerRadius(16)
                                        .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                    } else {
                                        LazyVStack(spacing: 12) {
                                            ForEach(combination.jewelries) { jewelry in
                                                JewelryItemCard(jewelry: jewelry) {
                                                    if let currentCombination = combinationStore.getCombination(by: combinationId) {
                                                        combinationStore.removeJewelryFromCombination(jewelry, from: currentCombination)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    Button(action: {
                                        showingAddJewelry = true
                                    }) {
                                        HStack {
                                            Image(systemName: "plus")
                                                .font(.system(size: 16, weight: .bold))
                                            Text("Add Jewelry")
                                                .font(.bauhausBold(16))
                                        }
                                        .foregroundColor(Color.theme.buttonText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.theme.buttonBackground)
                                        .cornerRadius(25)
                                        .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                    }
                                    
                                    Button(action: {
                                        showingEditCombination = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .bold))
                                            Text("Edit Combination")
                                                .font(.bauhausBold(16))
                                        }
                                        .foregroundColor(Color.theme.secondaryButtonText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.theme.secondaryButtonBackground)
                                        .cornerRadius(25)
                                        .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .bold))
                                            Text("Delete Combination")
                                                .font(.bauhausBold(16))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.red)
                                        .cornerRadius(25)
                                        .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 40)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                dismiss()
                            }
                            .font(.bauhausRegular(16))
                            .foregroundColor(Color.theme.primaryBlue)
                        }
                    }
                }
                .sheet(isPresented: $showingEditCombination) {
                    AddCombinationView(combinationStore: combinationStore, combinationToEdit: combination)
                }
                .sheet(isPresented: $showingAddJewelry) {
                    if let currentCombination = combinationStore.getCombination(by: combinationId) {
                        AddJewelryView(combination: currentCombination, combinationStore: combinationStore)
                    }
                }
                .alert("Delete Combination", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let currentCombination = combinationStore.getCombination(by: combinationId) {
                            combinationStore.deleteCombination(currentCombination)
                        }
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this combination? This action cannot be undone.")
                }
            } else {
                Text("Combination not found")
                    .font(.bauhausBold(18))
                    .foregroundColor(Color.theme.primaryText)
            }
        }
    }
}

struct JewelryItemCard: View {
    let jewelry: Jewelry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: jewelry.type.iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.theme.primaryBlue)
                .frame(width: 40, height: 40)
                .background(Color.theme.primaryBlue.opacity(0.1))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(jewelry.name.isEmpty ? jewelry.type.displayName : jewelry.name)
                    .font(.bauhausBold(16))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(jewelry.type.displayName)
                    .font(.bauhausRegular(14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.red.opacity(0.7))
            }
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
    }
}
