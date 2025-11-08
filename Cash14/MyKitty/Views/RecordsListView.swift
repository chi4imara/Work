import SwiftUI

struct RecordsListView: View {
    @ObservedObject var petStore: PetStore
    @State private var selectedFilter: RecordFilter = .all
    @State private var searchText = ""
    @State private var showingFilter = false
    @State private var selectedPet: Pet? = nil
    @State private var showingAddRecord = false
    @State private var recordTypeToAdd: RecordTypeToAdd = .vaccination
    
    enum RecordTypeToAdd {
        case vaccination
        case procedure
    }
    
    enum RecordFilter: String, CaseIterable {
        case all = "All"
        case vaccinations = "Vaccinations"
        case procedures = "Procedures"
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
                    
                    if filteredRecords.isEmpty {
                        emptyStateView
                    } else {
                        recordsListView
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedPet) { pet in
                PetDetailView(petStore: petStore, pet: pet)
            }
            .sheet(isPresented: $showingAddRecord) {
                AddRecordSelectionView(
                    petStore: petStore,
                    recordType: recordTypeToAdd,
                    isPresented: $showingAddRecord
                )
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Records")
                    .font(FontManager.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(filteredRecords.count) record(s)")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: {
                showingAddRecord = true
            }) {
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
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var filterTabsView: some View {
        HStack(spacing: 0) {
            ForEach(RecordFilter.allCases, id: \.self) { filter in
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
            
            TextField("Search records...", text: $searchText)
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
            Image(systemName: "doc.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No records found")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add records in pet profiles to see them here")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private var recordsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredRecords, id: \.id) { record in
                    RecordCard(record: record, petStore: petStore) {
                        if let pet = petStore.pets.first(where: { $0.id.uuidString == record.petId }) {
                            selectedPet = pet
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var filteredRecords: [RecordItem] {
        var records: [RecordItem] = []
        
        if selectedFilter == .all || selectedFilter == .vaccinations {
            records += petStore.activeVaccinations.map { vaccination in
                RecordItem(
                    id: vaccination.id.uuidString,
                    petId: vaccination.petId.uuidString,
                    type: .vaccination,
                    title: vaccination.vaccineName,
                    petName: petStore.pets.first { $0.id == vaccination.petId }?.name ?? "Unknown",
                    date: vaccination.date,
                    clinic: vaccination.clinic,
                    comment: vaccination.comment
                )
            }
        }
        
        if selectedFilter == .all || selectedFilter == .procedures {
            records += petStore.activeProcedures.map { procedure in
                RecordItem(
                    id: procedure.id.uuidString,
                    petId: procedure.petId.uuidString,
                    type: .procedure,
                    title: procedure.type.rawValue,
                    petName: petStore.pets.first { $0.id == procedure.petId }?.name ?? "Unknown",
                    date: procedure.date,
                    clinic: nil,
                    comment: procedure.comment
                )
            }
        }
        
        if !searchText.isEmpty {
            records = records.filter { record in
                record.title.localizedCaseInsensitiveContains(searchText) ||
                record.petName.localizedCaseInsensitiveContains(searchText) ||
                (record.comment?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return records.sorted { $0.date > $1.date }
    }
}

struct RecordItem {
    let id: String
    let petId: String
    let type: RecordType
    let title: String
    let petName: String
    let date: Date
    let clinic: String?
    let comment: String?
    
    enum RecordType {
        case vaccination
        case procedure
        
        var icon: String {
            switch self {
            case .vaccination:
                return "syringe"
            case .procedure:
                return "stethoscope"
            }
        }
        
        var color: Color {
            switch self {
            case .vaccination:
                return AppColors.primaryBlue
            case .procedure:
                return AppColors.accentPurple
            }
        }
    }
}

struct RecordCard: View {
    let record: RecordItem
    let petStore: PetStore
    let onTap: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showingArchiveAlert = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.error)
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "archivebox.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Archive")
                                .font(FontManager.small)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }
                )
                .opacity(offset.width < -50 ? 1 : 0)
            
            HStack(spacing: 16) {
                Image(systemName: record.type.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                record.type.color,
                                record.type.color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(record.title)
                            .font(FontManager.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(formattedDate)
                            .font(FontManager.small)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text("Pet: \(record.petName)")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if let clinic = record.clinic, !clinic.isEmpty {
                        Text("Clinic: \(clinic)")
                            .font(FontManager.small)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    if let comment = record.comment, !comment.isEmpty {
                        Text(comment)
                            .font(FontManager.small)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
            .onTapGesture {
                onTap()
            }
        }
        .alert("Archive Record", isPresented: $showingArchiveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                archiveRecord()
            }
        } message: {
            Text("Are you sure you want to archive this record?")
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: record.date)
    }
    
    private func archiveRecord() {
        if let vaccination = petStore.vaccinations.first(where: { $0.id.uuidString == record.id }) {
            petStore.archiveVaccination(vaccination)
        } else if let procedure = petStore.procedures.first(where: { $0.id.uuidString == record.id }) {
            petStore.archiveProcedure(procedure)
        }
    }
}

struct RecordsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsListView(petStore: PetStore())
    }
}
