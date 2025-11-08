import SwiftUI

struct PetDetailView: View {
    @ObservedObject var petStore: PetStore
    let pet: Pet
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: PetDetailTab = .vaccinations
    @State private var showingEditPet = false
    @State private var showingArchiveAlert = false
    @State private var showingAddVaccination = false
    @State private var showingAddProcedure = false
    @State private var newNoteText = ""
    @State private var showingAddNote = false
    
    enum PetDetailTab: String, CaseIterable {
        case vaccinations = "Vaccinations"
        case procedures = "Procedures"
        case notes = "Notes"
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        petHeaderView
                        
                        basicInfoSection
                        
                        recordsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditPet) {
                AddEditPetView(petStore: petStore, pet: pet)
            }
            .sheet(isPresented: $showingAddVaccination) {
                AddEditVaccinationView(petStore: petStore, petId: pet.id, vaccination: nil)
            }
            .sheet(isPresented: $showingAddProcedure) {
                AddEditProcedureView(petStore: petStore, petId: pet.id, procedure: nil)
            }
            .alert("Archive Pet", isPresented: $showingArchiveAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Archive", role: .destructive) {
                    petStore.archivePet(pet)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to archive \(pet.name)? This will also archive all related records.")
            }
            .alert("Add Note", isPresented: $showingAddNote) {
                TextField("Enter note", text: $newNoteText)
                Button("Cancel", role: .cancel) {
                    newNoteText = ""
                }
                Button("Add") {
                    addNote()
                }
            } message: {
                Text("Add a new note for \(pet.name)")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private var petHeaderView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button("Edit Pet") {
                        showingEditPet = true
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
            
            VStack(spacing: 16) {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.primaryBlue.opacity(0.8),
                                AppColors.accentPurple.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(pet.name.prefix(1)).uppercased())
                            .font(FontManager.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 8) {
                    Text(pet.name)
                        .font(FontManager.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(pet.speciesBreed)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(spacing: 16) {
                        InfoBadge(icon: genderIcon, text: pet.gender.rawValue, color: genderColor)
                        InfoBadge(icon: "calendar", text: pet.age, color: AppColors.primaryBlue)
                    }
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Information")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                InfoRow(title: "Birth Date", value: formattedBirthDate)
                
                if let adoptionDate = pet.adoptionDate {
                    InfoRow(title: "Adoption Date", value: formattedDate(adoptionDate))
                }
                
                if let weight = pet.weight {
                    InfoRow(title: "Weight", value: String(format: "%.1f kg", weight))
                }
                
                if let identification = pet.identification {
                    InfoRow(title: "Identification", value: identification)
                }
                
                if let color = pet.color {
                    InfoRow(title: "Color", value: color)
                }
                
                if let allergies = pet.allergies {
                    InfoRow(title: "Allergies", value: allergies)
                }
                
                if let notes = pet.notes {
                    InfoRow(title: "Notes", value: notes)
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    private var recordsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Health Records")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Menu {
                    Button("Add Vaccination") { showingAddVaccination = true }
                    Button("Add Procedure") { showingAddProcedure = true }
                    Button("Add Note") { showingAddNote = true }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(AppColors.primaryBlue)
                        .clipShape(Circle())
                }
            }
            
            HStack(spacing: 0) {
                ForEach(PetDetailTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                    }) {
                        Text(tab.rawValue)
                            .font(FontManager.body)
                            .foregroundColor(selectedTab == tab ? .white : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                selectedTab == tab ?
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
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(4)
            .background(Color.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Group {
                switch selectedTab {
                case .vaccinations:
                    vaccinationsView
                case .procedures:
                    proceduresView
                case .notes:
                    notesView
                }
            }
        }
    }
    
    private var vaccinationsView: some View {
        let vaccinations = petStore.getVaccinations(for: pet.id)
        
        return VStack(spacing: 12) {
            if vaccinations.isEmpty {
                EmptyStateCard(
                    icon: "syringe",
                    title: "No vaccinations yet",
                    subtitle: "Add the first vaccination record"
                ) {
                    showingAddVaccination = true
                }
            } else {
                ForEach(vaccinations) { vaccination in
                    VaccinationCard(vaccination: vaccination, petStore: petStore)
                }
            }
        }
    }
    
    private var proceduresView: some View {
        let procedures = petStore.getProcedures(for: pet.id)
        
        return VStack(spacing: 12) {
            if procedures.isEmpty {
                EmptyStateCard(
                    icon: "stethoscope",
                    title: "No procedures yet",
                    subtitle: "Add the first procedure record"
                ) {
                    showingAddProcedure = true
                }
            } else {
                ForEach(procedures) { procedure in
                    ProcedureCard(procedure: procedure, petStore: petStore)
                }
            }
        }
    }
    
    private var notesView: some View {
        let notes = petStore.getNotes(for: pet.id)
        
        return VStack(spacing: 12) {
            if notes.isEmpty {
                EmptyStateCard(
                    icon: "note.text",
                    title: "No notes yet",
                    subtitle: "Add the first note"
                ) {
                    showingAddNote = true
                }
            } else {
                ForEach(notes) { note in
                    NoteCard(note: note, petStore: petStore)
                }
            }
        }
    }
    
    private var genderIcon: String {
        switch pet.gender {
        case .male:
            return "figure"
        case .female:
            return "figure.dress.line.vertical.figure"
        case .unknown:
            return "questionmark.circle"
        }
    }
    
    private var genderColor: Color {
        switch pet.gender {
        case .male:
            return AppColors.primaryBlue
        case .female:
            return AppColors.softPink
        case .unknown:
            return AppColors.secondaryText
        }
    }
    
    private var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: pet.birthDate)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func addNote() {
        guard !newNoteText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let note = Note(
            petId: pet.id,
            text: newNoteText.trimmingCharacters(in: .whitespaces),
            date: Date()
        )
        
        petStore.addNote(note)
        newNoteText = ""
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
            
            Text(text)
                .font(FontManager.small)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    var isGrayed: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.body)
                .foregroundColor(isGrayed ? Color.gray.opacity(0.8) : AppColors.secondaryText)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(FontManager.body)
                .foregroundColor(isGrayed ? Color.gray : AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct EmptyStateCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 4) {
                Text(title)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(subtitle)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button("Add First Record") {
                action()
            }
            .font(FontManager.body)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppColors.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
        )
    }
}


struct VaccinationCard: View {
    let vaccination: Vaccination
    let petStore: PetStore
    
    var body: some View {
        Text("Vaccination: \(vaccination.vaccineName)")
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ProcedureCard: View {
    let procedure: Procedure
    let petStore: PetStore
    
    var body: some View {
        Text("Procedure: \(procedure.type.rawValue)")
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NoteCard: View {
    let note: Note
    let petStore: PetStore
    
    var body: some View {
        Text("Note: \(note.text)")
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePet = Pet(
            name: "Fluffy",
            species: "Cat",
            breed: "Persian",
            gender: .female,
            birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            adoptionDate: nil,
            weight: 4.5,
            identification: nil,
            color: "White",
            allergies: nil,
            notes: "Very playful"
        )
        
        PetDetailView(petStore: PetStore(), pet: samplePet)
    }
}
