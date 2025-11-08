import SwiftUI

struct ArchiveView: View {
    @ObservedObject var petStore: PetStore
    @State private var selectedFilter: ArchiveFilter = .all
    @State private var searchText = ""
    @State private var showingClearAlert = false
    @State private var selectedItems: Set<String> = []
    @State private var isSelectionMode = false
    @State private var selectedPet: Pet? = nil
    
    enum ArchiveFilter: String, CaseIterable {
        case all = "All"
        case pets = "Pets"
        case records = "Records"
    }
    
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
                    
                    searchBarView
                    
                    filterTabsView
                    
                    if filteredArchiveItems.isEmpty {
                        emptyStateView
                    } else {
                        archiveListView
                    }
                    
                    if isSelectionMode && !selectedItems.isEmpty {
                        selectionToolbar
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .alert("Clear Archive", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    petStore.clearArchive()
                }
            } message: {
                Text("Are you sure you want to permanently delete all archived items?")
            }
            .sheet(item: $selectedPet) { pet in
                ArchivedPetDetailView(pet: pet, petStore: petStore)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Archive")
                    .font(FontManager.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(filteredArchiveItems.count) item(s)")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
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
                    Button("Clear All") {
                        showingClearAlert = true
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.error)
                    .disabled(filteredArchiveItems.isEmpty)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var filterTabsView: some View {
        HStack(spacing: 0) {
            ForEach(ArchiveFilter.allCases, id: \.self) { filter in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedFilter = filter
                    }
                }) {
                    Text(filter.rawValue)
                        .font(FontManager.poppinsMedium(size: 12))
                        .foregroundColor(selectedFilter == filter ? .white : AppColors.primaryText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            selectedFilter == filter ?
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
                                    Color.clear,
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 20)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search archive...", text: $searchText)
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "archivebox")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Archive is empty")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Archived items will appear here")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private var archiveListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredArchiveItems, id: \.id) { item in
                    ArchiveItemCard(
                        item: item,
                        petStore: petStore,
                        isSelected: selectedItems.contains(item.id),
                        isSelectionMode: isSelectionMode
                    ) {
                        if isSelectionMode {
                            toggleSelection(for: item.id)
                        } else if item.type == .pet {
                            if let pet = petStore.pets.first(where: { $0.id.uuidString == item.id }) {
                                selectedPet = pet
                            }
                        }
                    } onLongPress: {
                        if !isSelectionMode {
                            enterSelectionMode(with: item.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var selectionToolbar: some View {
        HStack(spacing: 16) {
            Button("Restore Selected (\(selectedItems.count))") {
                restoreSelectedItems()
            }
            .font(FontManager.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.success)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Button("Delete Selected (\(selectedItems.count))") {
                deleteSelectedItems()
            }
            .font(FontManager.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.error)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var filteredArchiveItems: [ArchiveItem] {
        var items: [ArchiveItem] = []
        
        if selectedFilter == .all || selectedFilter == .pets {
            items += petStore.archivedPets.map { pet in
                ArchiveItem(
                    id: pet.id.uuidString,
                    type: .pet,
                    title: pet.name,
                    subtitle: pet.speciesBreed,
                    archivedDate: pet.archivedDate ?? Date()
                )
            }
        }
        
        if selectedFilter == .all || selectedFilter == .records {
            items += petStore.archivedVaccinations.map { vaccination in
                ArchiveItem(
                    id: vaccination.id.uuidString,
                    type: .vaccination,
                    title: vaccination.vaccineName,
                    subtitle: "Pet: \(petStore.pets.first { $0.id == vaccination.petId }?.name ?? "Unknown")",
                    archivedDate: vaccination.archivedDate ?? Date()
                )
            }
            
            items += petStore.archivedProcedures.map { procedure in
                ArchiveItem(
                    id: procedure.id.uuidString,
                    type: .procedure,
                    title: procedure.type.rawValue,
                    subtitle: "Pet: \(petStore.pets.first { $0.id == procedure.petId }?.name ?? "Unknown")",
                    archivedDate: procedure.archivedDate ?? Date()
                )
            }
        }
        
        if !searchText.isEmpty {
            items = items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items.sorted { $0.archivedDate > $1.archivedDate }
    }
    
    private func toggleSelection(for itemId: String) {
        if selectedItems.contains(itemId) {
            selectedItems.remove(itemId)
        } else {
            selectedItems.insert(itemId)
        }
    }
    
    private func enterSelectionMode(with itemId: String) {
        isSelectionMode = true
        selectedItems.insert(itemId)
    }
    
    private func exitSelectionMode() {
        isSelectionMode = false
        selectedItems.removeAll()
    }
    
    private func restoreSelectedItems() {
        for itemId in selectedItems {
            if let pet = petStore.pets.first(where: { $0.id.uuidString == itemId }) {
                petStore.restorePet(pet)
            } else if let vaccination = petStore.vaccinations.first(where: { $0.id.uuidString == itemId }) {
                petStore.restoreVaccination(vaccination)
            } else if let procedure = petStore.procedures.first(where: { $0.id.uuidString == itemId }) {
                petStore.restoreProcedure(procedure)
            }
        }
        exitSelectionMode()
    }
    
    private func deleteSelectedItems() {
        for itemId in selectedItems {
            if let pet = petStore.pets.first(where: { $0.id.uuidString == itemId }) {
                petStore.deletePetPermanently(pet)
            } else if let vaccination = petStore.vaccinations.first(where: { $0.id.uuidString == itemId }) {
                petStore.deleteVaccinationPermanently(vaccination)
            } else if let procedure = petStore.procedures.first(where: { $0.id.uuidString == itemId }) {
                petStore.deleteProcedurePermanently(procedure)
            }
        }
        exitSelectionMode()
    }
}

struct ArchiveItem {
    let id: String
    let type: ArchiveItemType
    let title: String
    let subtitle: String
    let archivedDate: Date
    
    enum ArchiveItemType {
        case pet
        case vaccination
        case procedure
        
        var icon: String {
            switch self {
            case .pet:
                return "pawprint.fill"
            case .vaccination:
                return "syringe"
            case .procedure:
                return "stethoscope"
            }
        }
        
        var color: Color {
            switch self {
            case .pet:
                return AppColors.primaryBlue
            case .vaccination:
                return AppColors.accentPurple
            case .procedure:
                return AppColors.softPink
            }
        }
    }
}

struct ArchiveItemCard: View {
    let item: ArchiveItem
    let petStore: PetStore
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showingRestoreAlert = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.success)
                .overlay(
                    HStack {
                        VStack {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Restore")
                                .font(FontManager.small)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                )
                .opacity(offset.width > 50 ? 1 : 0)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.error)
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Delete")
                                .font(FontManager.small)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }
                )
                .opacity(offset.width < -50 ? 1 : 0)
            
            HStack(spacing: 16) {
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                
                Image(systemName: item.type.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(item.type.color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(item.subtitle)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    Text("Archived: \(formattedArchivedDate)")
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? AppColors.primaryBlue : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture {
                if !isSelectionMode {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    onLongPress()
                }
            }
        }
        .alert("Restore Item", isPresented: $showingRestoreAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Restore") {
                restoreItem()
            }
        } message: {
            Text("Are you sure you want to restore this item?")
        }
        .alert("Delete Permanently", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("Are you sure you want to permanently delete this item? This action cannot be undone.")
        }
    }
    
    private var formattedArchivedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: item.archivedDate)
    }
    
    private func restoreItem() {
        if let pet = petStore.pets.first(where: { $0.id.uuidString == item.id }) {
            petStore.restorePet(pet)
        } else if let vaccination = petStore.vaccinations.first(where: { $0.id.uuidString == item.id }) {
            petStore.restoreVaccination(vaccination)
        } else if let procedure = petStore.procedures.first(where: { $0.id.uuidString == item.id }) {
            petStore.restoreProcedure(procedure)
        }
    }
    
    private func deleteItem() {
        if let pet = petStore.pets.first(where: { $0.id.uuidString == item.id }) {
            petStore.deletePetPermanently(pet)
        } else if let vaccination = petStore.vaccinations.first(where: { $0.id.uuidString == item.id }) {
            petStore.deleteVaccinationPermanently(vaccination)
        } else if let procedure = petStore.procedures.first(where: { $0.id.uuidString == item.id }) {
            petStore.deleteProcedurePermanently(procedure)
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(petStore: PetStore())
    }
}
