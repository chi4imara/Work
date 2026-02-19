import SwiftUI

struct AddSessionView: View {
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    var onSave: (Session) -> Void
    
    @State private var sessionTitle = ""
    @State private var selectedMaster: Master?
    @State private var selectedType: MassageType = .relaxation
    @State private var selectedDuration: SessionDuration = .sixty
    @State private var selectedDate = Date()
    @State private var selectedLocation: SessionLocation = .salon
    @State private var notes = ""
    @State private var showingConfirmation = false
    @State private var showingAddMaster = false
    @State private var newlyAddedMaster: Master?
    
    private var masters: [Master] { appState.masters }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        
                        masterSelectionSection
                        
                        typeSelectionSection
                        
                        durationLocationSection
                        
                        dateSelectionSection
                        
                        notesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .alert("Session Added!", isPresented: $showingConfirmation) {
                Button("OK", role: .cancel) {
                    showingConfirmation = false
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
            } message: {
                Text("Your session has been successfully added to your bookings.")
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
            
            TextField("Enter session name...", text: $sessionTitle)
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
    
    private var masterSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Select Master")
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
            
            if masters.isEmpty {
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
                    ForEach(masters) { master in
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
    
    private var typeSelectionSection: some View {
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
    
    private var durationLocationSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Duration")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                VStack(spacing: 8) {
                    ForEach(SessionDuration.allCases, id: \.self) { duration in
                        Button(action: {
                            selectedDuration = duration
                        }) {
                            Text(duration.displayName)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(selectedDuration == duration ? .white : ColorTheme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedDuration == duration ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                                        .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
                                )
                        }
                        .animation(.spring(response: 0.3), value: selectedDuration)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Location")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                VStack(spacing: 8) {
                    ForEach(SessionLocation.allCases, id: \.self) { location in
                        Button(action: {
                            selectedLocation = location
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: location.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedLocation == location ? .white : ColorTheme.textSecondary)
                                
                                Text(location.rawValue)
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(selectedLocation == location ? .white : ColorTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedLocation == location ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                                    .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
                            )
                        }
                        .animation(.spring(response: 0.3), value: selectedLocation)
                    }
                }
            }
        }
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Date")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
                .accentColor(ColorTheme.primaryBlue)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Notes (Optional)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Any preferences or special requests...", text: $notes, axis: .vertical)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
                .lineLimit(3...6)
        }
    }
    
    private func saveSession() {
        guard let master = selectedMaster else { return }
        let session = Session(
            title: sessionTitle.trimmingCharacters(in: .whitespaces),
            master: master,
            type: selectedType,
            duration: selectedDuration,
            date: selectedDate,
            price: Double(selectedDuration.rawValue) * (master.pricePerHour / 60.0),
            status: .scheduled,
            notes: notes,
            location: selectedLocation
        )
        onSave(session)
        showingConfirmation = true
    }
}

struct MasterSelectionCard: View {
    let master: Master
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(master.name.prefix(1)))
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(master.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(ColorTheme.primaryYellow)
                            
                            Text(String(format: "%.1f", master.rating))
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Text("•")
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Text("$\(Int(master.pricePerHour))/hr")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        if master.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(ColorTheme.primaryBlue)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.textSecondary.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(ColorTheme.primaryBlue.opacity(0.1)) : AnyShapeStyle(ColorTheme.cardGradient))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.primaryBlue : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: ColorTheme.shadowColor, radius: isSelected ? 8 : 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct TypeSelectionCard: View {
    let type: MassageType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : type.color)
                
                Text(type.rawValue)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? type.color : ColorTheme.cardBackground)
                    .shadow(color: ColorTheme.shadowColor, radius: isSelected ? 8 : 4, x: 0, y: 2)
            )
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    AddSessionView(onSave: { _ in })
        .environmentObject(AppStateManager())
}
