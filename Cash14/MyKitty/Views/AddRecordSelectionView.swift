import SwiftUI

struct AddRecordSelectionView: View {
    @ObservedObject var petStore: PetStore
    let recordType: RecordsListView.RecordTypeToAdd
    @Binding var isPresented: Bool
    
    @State private var selectedPet: Pet? = nil
    @State private var showingAddForm = false
    @State private var selectedRecordType: RecordsListView.RecordTypeToAdd = .vaccination
    
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
                
                    VStack(spacing: 20) {
                        headerView
                        
                        recordTypeSelection
                        
                        if petStore.activePets.isEmpty {
                            emptyStateView
                        } else {
                            petSelectionList
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedPet) { pet in
                switch selectedRecordType {
                case .vaccination:
                    AddEditVaccinationView(petStore: petStore, petId: pet.id, vaccination: nil)
                        .onDisappear {
                            selectedPet = nil
                        }
                case .procedure:
                    AddEditProcedureView(petStore: petStore, petId: pet.id, procedure: nil)
                        .onDisappear {
                            selectedPet = nil
                        }
                }
            }
        }
        .onAppear {
            selectedRecordType = recordType
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                isPresented = false
            }
            .font(FontManager.body)
            .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            Spacer()
            
            Text("Select Pet")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, -5)
        .padding(.top, 16)
    }
    
    private var recordTypeSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Record Type")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 12) {
                Button(action: {
                    selectedRecordType = .vaccination
                }) {
                    HStack {
                        Image(systemName: "syringe")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Vaccination")
                            .font(FontManager.subheadline)
                    }
                    .foregroundColor(selectedRecordType == .vaccination ? .white : AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        selectedRecordType == .vaccination ?
                        AppColors.primaryBlue :
                        Color.white.opacity(0.9)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedRecordType == .vaccination ? Color.clear : AppColors.primaryBlue.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    selectedRecordType = .procedure
                }) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Procedure")
                            .font(FontManager.subheadline)
                    }
                    .foregroundColor(selectedRecordType == .procedure ? .white : AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        selectedRecordType == .procedure ?
                        AppColors.accentPurple :
                        Color.white.opacity(0.9)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedRecordType == .procedure ? Color.clear : AppColors.accentPurple.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var petSelectionList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a pet to add \(selectedRecordType == .vaccination ? "vaccination" : "procedure") record:")
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(petStore.activePets) { pet in
                        PetSelectionCard(pet: pet) {
                            selectedPet = pet
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "pawprint")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No pets available")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add a pet first to create records")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Cancel") {
                isPresented = false
            }
            .font(FontManager.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

struct PetSelectionCard: View {
    let pet: Pet
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
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
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(pet.name.prefix(1)).uppercased())
                            .font(FontManager.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(pet.name)
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(pet.speciesBreed)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Age: \(pet.age)")
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddRecordSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordSelectionView(
            petStore: PetStore(),
            recordType: .vaccination,
            isPresented: .constant(true)
        )
    }
}
