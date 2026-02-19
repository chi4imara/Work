import SwiftUI

struct AddCatalogSessionView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    var onSave: (Session) -> Void
    
    @State private var sessionTitle = ""
    @State private var selectedMaster: Master?
    @State private var selectedType: MassageType = .relaxation
    @State private var selectedDuration: SessionDuration = .sixty
    @State private var price = 100.0
    @State private var selectedLocation: SessionLocation = .salon
    @State private var showingAddMaster = false
    @State private var newlyAddedMaster: Master?
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        masterSection
                        typeSection
                        durationSection
                        priceSection
                        locationSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Session")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSession()
                    }
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingAddMaster) {
            AddMasterView(savedMaster: $newlyAddedMaster)
                .onDisappear {
                    if let master = newlyAddedMaster {
                        appState.addMaster(master)
                        selectedMaster = master
                        newlyAddedMaster = nil
                    }
                }
        }
    }
    
    private var isFormValid: Bool {
        !sessionTitle.trimmingCharacters(in: .whitespaces).isEmpty && selectedMaster != nil
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Title")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Enter session name", text: $sessionTitle)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
        }
    }
    
    private var masterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Master")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                Spacer()
                Button(action: { showingAddMaster = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Master")
                            .font(.ubuntu(14, weight: .medium))
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            
            if appState.masters.isEmpty {
                Text("No masters yet. Tap \"Add Master\" to create one.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                    )
            } else {
                VStack(spacing: 8) {
                    ForEach(appState.masters) { master in
                        MasterSelectionCard(
                            master: master,
                            isSelected: selectedMaster?.id == master.id
                        ) {
                            selectedMaster = master
                        }
                    }
                }
            }
        }
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Massage Type")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(MassageType.allCases, id: \.self) { type in
                    TypeSelectionCard(
                        type: type,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                }
            }
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duration")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(SessionDuration.allCases, id: \.self) { duration in
                    Button(action: { selectedDuration = duration }) {
                        Text(duration.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(selectedDuration == duration ? .white : ColorTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedDuration == duration ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                            )
                    }
                }
            }
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price: $\(Int(price))")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Slider(value: $price, in: 20...500, step: 5)
                .accentColor(ColorTheme.primaryBlue)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(SessionLocation.allCases, id: \.self) { location in
                    Button(action: { selectedLocation = location }) {
                        HStack(spacing: 6) {
                            Image(systemName: location.icon)
                            Text(location.rawValue)
                                .font(.ubuntu(14, weight: .medium))
                        }
                        .foregroundColor(selectedLocation == location ? .white : ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedLocation == location ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                        )
                    }
                }
            }
        }
    }
    
    private func saveSession() {
        guard let master = selectedMaster else { return }
        let session = Session(
            title: sessionTitle.trimmingCharacters(in: .whitespaces),
            master: master,
            type: selectedType,
            duration: selectedDuration,
            date: Date(),
            price: price,
            status: .scheduled,
            notes: "",
            location: selectedLocation
        )
        onSave(session)
        dismiss()
    }
}
