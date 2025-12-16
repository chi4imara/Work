import SwiftUI

struct AddPerfumeView: View {
    @ObservedObject var store: PerfumeStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var brand = ""
    @State private var notes = ""
    @State private var selectedSeason = Perfume.Season.universal
    @State private var selectedMood = Perfume.Mood.casual
    @State private var favoriteCombinations = ""
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fragrance Name *")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("Enter fragrance name", text: $name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Brand *")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("Enter brand name", text: $brand)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("e.g., vanilla, jasmine, patchouli", text: $notes, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .lineLimit(3...6)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Season")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                Menu {
                                    ForEach(Perfume.Season.allCases, id: \.self) { season in
                                        Button(season.rawValue) {
                                            selectedSeason = season
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedSeason.rawValue)
                                            .font(.ubuntu(16))
                                            .foregroundColor(.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondaryText)
                                    }
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mood")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                Menu {
                                    ForEach(Perfume.Mood.allCases, id: \.self) { mood in
                                        Button(mood.rawValue) {
                                            selectedMood = mood
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedMood.rawValue)
                                            .font(.ubuntu(16))
                                            .foregroundColor(.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondaryText)
                                    }
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Favorite Combinations")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("e.g., pairs well with warm vanilla scents", text: $favoriteCombinations, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .lineLimit(2...4)
                            }
                        }
                        
                        Text("Add at least name and brand to save the fragrance")
                            .font(.ubuntu(14))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Button(action: savePerfume) {
                            Text("Save Fragrance")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(canSave ? .primaryText : .secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(canSave ? AnyShapeStyle(AppGradients.yellowGradient) : AnyShapeStyle(Color.surfaceBackground))
                                .cornerRadius(25)
                        }
                        .disabled(!canSave)
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Fragrance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func savePerfume() {
        let newPerfume = Perfume(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            season: selectedSeason,
            mood: selectedMood,
            favoriteCombinations: favoriteCombinations.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        store.addPerfume(newPerfume)
        presentationMode.wrappedValue.dismiss()
    }
}
