import SwiftUI

struct ArchivedPetDetailView: View {
    let pet: Pet
    let petStore: PetStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingRestoreAlert = false
    @State private var showingDeleteAlert = false
    
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
                        headerView
                        
                        petInfoCard
                        
                        basicInfoSection
                        
                        archiveInfoSection
                        
                        actionButtonsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .alert("Restore Pet", isPresented: $showingRestoreAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Restore") {
                    petStore.restorePet(pet)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to restore \(pet.name) back to the main pets list?")
            }
            .alert("Delete Permanently", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    petStore.deletePetPermanently(pet)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to permanently delete \(pet.name)? This action cannot be undone and will also delete all related records.")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Archived Pet")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Color.clear
                .frame(width: 36, height: 36)
        }
    }
    
    private var petInfoCard: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.6),
                            Color.gray.opacity(0.4)
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
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 8) {
                Text(pet.name)
                    .font(FontManager.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                
                Text(pet.speciesBreed)
                    .font(FontManager.subheadline)
                    .foregroundColor(Color.gray.opacity(0.8))
                
                HStack(spacing: 16) {
                    InfoBadge(icon: genderIcon, text: pet.gender.rawValue, color: Color.gray)
                    InfoBadge(icon: "calendar", text: pet.age, color: Color.gray)
                }
            }
        }
        .padding(20)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pet Information")
                .font(FontManager.headline)
                .foregroundColor(Color.gray)
            
            VStack(spacing: 12) {
                InfoRow(title: "Birth Date", value: formattedBirthDate, isGrayed: true)
                
                if let adoptionDate = pet.adoptionDate {
                    InfoRow(title: "Adoption Date", value: formattedDate(adoptionDate), isGrayed: true)
                }
                
                if let weight = pet.weight {
                    InfoRow(title: "Weight", value: String(format: "%.1f kg", weight), isGrayed: true)
                }
                
                if let identification = pet.identification {
                    InfoRow(title: "Identification", value: identification, isGrayed: true)
                }
                
                if let color = pet.color {
                    InfoRow(title: "Color", value: color, isGrayed: true)
                }
                
                if let allergies = pet.allergies {
                    InfoRow(title: "Allergies", value: allergies, isGrayed: true)
                }
                
                if let notes = pet.notes {
                    InfoRow(title: "Notes", value: notes, isGrayed: true)
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var archiveInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Archive Information")
                .font(FontManager.headline)
                .foregroundColor(Color.gray)
            
            VStack(spacing: 12) {
                if let archivedDate = pet.archivedDate {
                    InfoRow(title: "Archived Date", value: formattedDate(archivedDate), isGrayed: true)
                }
                
                InfoRow(title: "Status", value: "Archived", isGrayed: true)
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingRestoreAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Restore Pet")
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.success)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: AppColors.success.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Delete Permanently")
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.error)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: AppColors.error.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
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
}

struct ArchivedPetDetailView_Previews: PreviewProvider {
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
        
        ArchivedPetDetailView(pet: samplePet, petStore: PetStore())
    }
}
