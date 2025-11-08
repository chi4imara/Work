import SwiftUI

struct FilterView: View {
    @ObservedObject var petStore: PetStore
    @Binding var isPresented: Bool
    
    @State private var tempFilterSpecies: Set<String> = []
    @State private var tempFilterGender: Pet.Gender?
    @State private var tempSearchText: String = ""
    
    let speciesOptions = ["Dog", "Cat", "Bird", "Rodent", "Reptile", "Fish", "Other"]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.backgroundGradientStart,
                        AppColors.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Search by Name")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter pet name", text: $tempSearchText)
                                .font(FontManager.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Species")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(speciesOptions, id: \.self) { species in
                                    FilterOptionButton(
                                        title: species,
                                        isSelected: tempFilterSpecies.contains(species)
                                    ) {
                                        if tempFilterSpecies.contains(species) {
                                            tempFilterSpecies.remove(species)
                                        } else {
                                            tempFilterSpecies.insert(species)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Gender")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(Pet.Gender.allCases, id: \.self) { gender in
                                    FilterOptionButton(
                                        title: gender.rawValue,
                                        isSelected: tempFilterGender == gender
                                    ) {
                                        tempFilterGender = tempFilterGender == gender ? nil : gender
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filter Pets")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Reset") {
                    resetFilters()
                },
                trailing: Button("Apply") {
                    applyFilters()
                }
            )
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private func loadCurrentFilters() {
        tempFilterSpecies = petStore.filterSpecies
        tempFilterGender = petStore.filterGender
        tempSearchText = petStore.searchText
    }
    
    private func applyFilters() {
        petStore.filterSpecies = tempFilterSpecies
        petStore.filterGender = tempFilterGender
        petStore.searchText = tempSearchText
        isPresented = false
    }
    
    private func resetFilters() {
        tempFilterSpecies.removeAll()
        tempFilterGender = nil
        tempSearchText = ""
    }
}

struct FilterOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(isSelected ? .white : AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected ?
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.primaryBlue,
                        AppColors.accentPurple
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.9),
                        Color.white.opacity(0.9)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.clear : AppColors.primaryBlue.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(petStore: PetStore(), isPresented: .constant(true))
    }
}
