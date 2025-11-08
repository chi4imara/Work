import SwiftUI

struct PetsListView: View {
    @ObservedObject var petStore: PetStore
    @State private var showingAddPet = false
    @State private var showingFilter = false
    @State private var showingSort = false
    @State private var selectedPets: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var showingArchiveAlert = false
    @State private var showingEditPet: Pet? = nil
    @State private var showingRecords = false
    

    
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
                
                VStack(spacing: 0) {
                    headerView
                    
                    if hasActiveFilters {
                        filterPillsView
                    }
                    
                    if petStore.activePets.isEmpty {
                        emptyStateView
                    } else {
                        petsGridView
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddPet) {
                AddEditPetView(petStore: petStore, pet: nil)
            }
            .sheet(item: $showingEditPet) { pet in
                AddEditPetView(petStore: petStore, pet: pet)
            }
            .sheet(isPresented: $showingRecords) {
                RecordsListView(petStore: petStore)
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(petStore: petStore, isPresented: $showingFilter)
            }
            .actionSheet(isPresented: $showingSort) {
                sortActionSheet
            }
            .alert("Archive Selected Pets", isPresented: $showingArchiveAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Archive", role: .destructive) {
                    archiveSelectedPets()
                }
            } message: {
                Text("Are you sure you want to archive \(selectedPets.count) pet(s)?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Pets")
                    .font(FontManager.title)
                    .foregroundColor(AppColors.primaryText)
                
                HStack(spacing: 8) {
                    if !petStore.activePets.isEmpty {
                        Text("\(petStore.activePets.count) pet(s)")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Button("View Records") {
                        showingRecords = true
                    }
                    .font(FontManager.small)
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                if isSelectionMode {
                    Button("Cancel") {
                        exitSelectionMode()
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryBlue)
                } else {
                    Button(action: { showingAddPet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.primaryBlue,
                                        AppColors.accentPurple
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    
                    Menu {
                        Button("Filter") { showingFilter = true }
                        Button("Sort") { showingSort = true }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var filterPillsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(petStore.filterSpecies), id: \.self) { species in
                    FilterPill(text: "Species: \(species)") {
                        petStore.filterSpecies.remove(species)
                    }
                }
                
                if let gender = petStore.filterGender {
                    FilterPill(text: "Gender: \(gender.rawValue)") {
                        petStore.filterGender = nil
                    }
                }
                
                if !petStore.searchText.isEmpty {
                    FilterPill(text: "Search: \(petStore.searchText)") {
                        petStore.searchText = ""
                    }
                }
                
                Button("Clear All") {
                    petStore.clearFilters()
                }
                .font(FontManager.small)
                .foregroundColor(AppColors.primaryBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "pawprint")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(hasActiveFilters ? "No pets found" : "No pets yet")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(hasActiveFilters ? "Try adjusting your filters" : "Add your first pet to get started")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if hasActiveFilters {
                Button("Clear Filters") {
                    petStore.clearFilters()
                }
                .font(FontManager.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Button("Add First Pet") {
                    showingAddPet = true
                }
                .font(FontManager.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.primaryBlue,
                            AppColors.accentPurple
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private var petsGridView: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(petStore.activePets) { pet in
                        NavigationLink(
                            destination: PetDetailView(petStore: petStore, pet: pet),
                            label: {
                                PetCard(
                                    pet: pet,
                                    isSelected: selectedPets.contains(pet.id),
                                    isSelectionMode: isSelectionMode,
                                    onTap: {
                                        if isSelectionMode {
                                            toggleSelection(for: pet.id)
                                        }
                                    },
                                    onLongPress: {
                                        if !isSelectionMode {
                                            enterSelectionMode(with: pet.id)
                                        }
                                    },
                                    onArchive: {
                                        petStore.archivePet(pet)
                                    },
                                    onEdit: {
                                        showingEditPet = pet
                                    }
                                )
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .disabled(isSelectionMode)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            
            if isSelectionMode && !selectedPets.isEmpty {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button("Archive Selected (\(selectedPets.count))") {
                            showingArchiveAlert = true
                        }
                        .font(FontManager.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.error)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        !petStore.filterSpecies.isEmpty || petStore.filterGender != nil || !petStore.searchText.isEmpty
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort Pets"),
            buttons: [
                .default(Text("Name A-Z")) { petStore.sortOption = .name },
                .default(Text("Name Z-A")) { petStore.sortOption = .nameReverse },
                .default(Text("Date Added")) { petStore.sortOption = .dateAdded },
                .default(Text("Birth Date")) { petStore.sortOption = .birthDate },
                .cancel()
            ]
        )
    }
    
    private func toggleSelection(for petId: UUID) {
        if selectedPets.contains(petId) {
            selectedPets.remove(petId)
        } else {
            selectedPets.insert(petId)
        }
    }
    
    private func enterSelectionMode(with petId: UUID) {
        isSelectionMode = true
        selectedPets.insert(petId)
    }
    
    private func exitSelectionMode() {
        isSelectionMode = false
        selectedPets.removeAll()
    }
    
    private func archiveSelectedPets() {
        for petId in selectedPets {
            if let pet = petStore.pets.first(where: { $0.id == petId }) {
                petStore.archivePet(pet)
            }
        }
        exitSelectionMode()
    }
}

struct FilterPill: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(FontManager.small)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct PetsListView_Previews: PreviewProvider {
    static var previews: some View {
        PetsListView(petStore: PetStore())
    }
}
