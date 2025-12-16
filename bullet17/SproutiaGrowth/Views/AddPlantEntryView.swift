import SwiftUI

struct AddPlantEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    let mode: Mode
    
    enum Mode {
        case newPlant
        case newEntry(plant: PlantModel, selectedDate: Date? = nil)
        case editEntry(entry: EntryModel)
        
        var title: String {
            switch self {
            case .newPlant:
                return "New Plant"
            case .newEntry:
                return "New Entry"
            case .editEntry:
                return "Edit Entry"
            }
        }
    }
    
    @State private var plantName = ""
    @State private var plantLocation = ""
    @State private var plantType: PlantType? = nil
    @State private var plantStatus: PlantStatus = .healthy
    @State private var plantNote = ""
    
    @State private var selectedPlant: PlantModel?
    @State private var entryDate = Date()
    @State private var height = ""
    @State private var leaves = ""
    @State private var plantState: PlantState? = nil
    @State private var selectedCareTags: Set<CareTag> = []
    @State private var entryNote = ""
    
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private var allPlants: [PlantModel] {
        dataManager.plants.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        switch mode {
                        case .newPlant:
                            newPlantForm
                        case .newEntry(_), .editEntry:
                            newEntryForm
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveData()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .font(.playfair(.semiBold, size: 16))
                }
            }
        }
        .onAppear {
            setupInitialData()
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private var newPlantForm: some View {
        VStack(spacing: 20) {
            FormSection(title: "Plant Information") {
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Name *",
                        text: $plantName,
                        placeholder: "Enter plant name"
                    )
                    
                    CustomTextField(
                        title: "Location",
                        text: $plantLocation,
                        placeholder: "e.g., Kitchen windowsill"
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.playfair(.medium, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Menu {
                            Button("None") { plantType = nil }
                            ForEach(PlantType.allCases, id: \.self) { type in
                                Button(type.displayName) { plantType = type }
                            }
                        } label: {
                            HStack {
                                Text(plantType?.displayName ?? "Select type")
                                    .foregroundColor(plantType == nil ? AppColors.secondaryText : AppColors.primaryText)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding()
                            .background(AppColors.lightGray)
                            .cornerRadius(8)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.playfair(.medium, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Menu {
                            ForEach(PlantStatus.allCases, id: \.self) { status in
                                Button(status.displayName) { plantStatus = status }
                            }
                        } label: {
                            HStack {
                                Text(plantStatus.displayName)
                                    .foregroundColor(AppColors.primaryText)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding()
                            .background(AppColors.lightGray)
                            .cornerRadius(8)
                        }
                    }
                    
                    CustomTextField(
                        title: "Note",
                        text: $plantNote,
                        placeholder: "Additional notes",
                        isMultiline: true
                    )
                }
            }
        }
    }
    
    private var newEntryForm: some View {
        VStack(spacing: 20) {
            if case .newEntry = mode, allPlants.count > 1 {
                FormSection(title: "Plant") {
                    Menu {
                        ForEach(allPlants, id: \.id) { plant in
                            Button(plant.name) { selectedPlant = plant }
                        }
                    } label: {
                        HStack {
                            Text(selectedPlant?.name ?? "Select plant")
                                .foregroundColor(selectedPlant == nil ? AppColors.secondaryText : AppColors.primaryText)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding()
                        .background(AppColors.lightGray)
                        .cornerRadius(8)
                    }
                }
            }
            
            FormSection(title: "Measurements") {
                VStack(spacing: 16) {
                    DatePicker("Date", selection: $entryDate, displayedComponents: .date)
                        .font(.playfair(.medium, size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    CustomTextField(
                        title: "Height (cm)",
                        text: $height,
                        placeholder: "0.0",
                        keyboardType: .decimalPad
                    )
                    
                    CustomTextField(
                        title: "Leaves",
                        text: $leaves,
                        placeholder: "0",
                        keyboardType: .numberPad
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("State")
                            .font(.playfair(.medium, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Menu {
                            Button("None") { plantState = nil }
                            ForEach(PlantState.allCases, id: \.self) { state in
                                Button(state.displayName) { plantState = state }
                            }
                        } label: {
                            HStack {
                                Text(plantState?.displayName ?? "Select state")
                                    .foregroundColor(plantState == nil ? AppColors.secondaryText : AppColors.primaryText)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding()
                            .background(AppColors.lightGray)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            FormSection(title: "Care") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Care actions performed")
                        .font(.playfair(.medium, size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(CareTag.allCases, id: \.self) { tag in
                            Button(action: {
                                if selectedCareTags.contains(tag) {
                                    selectedCareTags.remove(tag)
                                } else {
                                    selectedCareTags.insert(tag)
                                }
                            }) {
                                HStack {
                                    Image(systemName: selectedCareTags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedCareTags.contains(tag) ? AppColors.primaryBlue : AppColors.secondaryText)
                                    
                                    Text(tag.displayName)
                                        .font(.playfair(.regular, size: 14))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedCareTags.contains(tag) ? AppColors.lightBlue.opacity(0.3) : AppColors.lightGray)
                                )
                            }
                        }
                    }
                }
            }
            
            FormSection(title: "Notes") {
                CustomTextField(
                    title: "Additional notes",
                    text: $entryNote,
                    placeholder: "Any observations or notes",
                    isMultiline: true
                )
            }
        }
    }
    
    private func setupInitialData() {
        switch mode {
        case .newPlant:
            break
        case .newEntry(let plant, let selectedDate):
            selectedPlant = plant
            if let selectedDate = selectedDate {
                entryDate = selectedDate
            }
        case .editEntry(let entry):
            selectedPlant = dataManager.getPlant(by: entry.plantId)
            entryDate = entry.date
            height = entry.height > 0 ? String(format: "%.1f", entry.height) : ""
            leaves = entry.leaves > 0 ? String(entry.leaves) : ""
            plantState = entry.state
            selectedCareTags = Set(entry.careTags)
            entryNote = entry.note ?? ""
        }
    }
    
    private func saveData() {
        switch mode {
        case .newPlant:
            savePlant()
        case .newEntry:
            saveEntry()
        case .editEntry(let entry):
            updateEntry(entry)
        }
    }
    
    private func savePlant() {
        guard !plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationError("Please enter a plant name")
            return
        }
        
        let plant = PlantModel(
            name: plantName.trimmingCharacters(in: .whitespacesAndNewlines),
            location: plantLocation.isEmpty ? nil : plantLocation,
            type: plantType,
            status: plantStatus,
            note: plantNote.isEmpty ? nil : plantNote
        )
        
        dataManager.addPlant(plant)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveEntry() {
        guard let plant = selectedPlant else {
            showValidationError("Please select a plant")
            return
        }
        
        let heightValue = Double(height) ?? 0
        let leavesValue = Int(leaves) ?? 0
        
        guard heightValue >= 0 && leavesValue >= 0 else {
            showValidationError("Values cannot be negative")
            return
        }
        
        guard hasMinimumContent(height: heightValue, leaves: leavesValue) else {
            showValidationError("Please add at least one measurement, state, care action, or note")
            return
        }
        
        let entry = EntryModel(
            plantId: plant.id,
            date: entryDate,
            height: heightValue,
            leaves: leavesValue,
            state: plantState,
            careTags: Array(selectedCareTags),
            note: entryNote.isEmpty ? nil : entryNote
        )
        
        dataManager.addEntry(entry)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func updateEntry(_ entry: EntryModel) {
        let heightValue = Double(height) ?? 0
        let leavesValue = Int(leaves) ?? 0
        
        guard heightValue >= 0 && leavesValue >= 0 else {
            showValidationError("Values cannot be negative")
            return
        }
        
        guard hasMinimumContent(height: heightValue, leaves: leavesValue) else {
            showValidationError("Please add at least one measurement, state, care action, or note")
            return
        }
        
        var updatedEntry = entry
        updatedEntry.date = entryDate
        updatedEntry.height = heightValue
        updatedEntry.leaves = leavesValue
        updatedEntry.state = plantState
        updatedEntry.careTags = Array(selectedCareTags)
        updatedEntry.note = entryNote.isEmpty ? nil : entryNote
        
        dataManager.updateEntry(updatedEntry)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func hasMinimumContent(height: Double, leaves: Int) -> Bool {
        return height > 0 || leaves > 0 || plantState != nil || !selectedCareTags.isEmpty || !entryNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    private func showValidationError(_ message: String) {
        validationMessage = message
        showingValidationError = true
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.2), radius: 2, x: 0, y: 1)
        )
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfair(.medium, size: 16))
                .foregroundColor(AppColors.primaryText)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.playfair(.regular, size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .frame(minHeight: 80)
                    .padding(8)
                    .background(AppColors.lightGray)
                    .cornerRadius(8)
                    .scrollContentBackground(.hidden)
            } else {
                TextField(placeholder, text: $text)
                    .font(.playfair(.regular, size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .keyboardType(keyboardType)
                    .padding()
                    .background(AppColors.lightGray)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    AddPlantEntryView(mode: .newPlant)
        .environmentObject(DataManager.shared)
}
