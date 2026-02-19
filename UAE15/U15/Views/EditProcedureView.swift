import SwiftUI

struct EditProcedureView: View {
    @Environment(\.dismiss) private var dismiss
    
    let procedure: Procedure
    let dataManager: DataManager
    
    @State private var selectedDate: Date
    @State private var barberName: String
    @State private var selectedServices: Set<ServiceType>
    @State private var customServices: [String]
    @State private var customServiceName: String
    @State private var comment: String
    @State private var showingCustomService = false
    
    init(procedure: Procedure, dataManager: DataManager) {
        self.procedure = procedure
        self.dataManager = dataManager
        self._selectedDate = State(initialValue: procedure.date)
        self._barberName = State(initialValue: procedure.barberName)
        
        var regularServices: Set<ServiceType> = []
        var customServicesList: [String] = []
        
        for service in procedure.services {
            if service.type == .other, let customName = service.customName {
                customServicesList.append(customName)
            } else {
                regularServices.insert(service.type)
            }
        }
        
        self._selectedServices = State(initialValue: regularServices)
        self._customServices = State(initialValue: customServicesList)
        self._customServiceName = State(initialValue: "")
        self._comment = State(initialValue: procedure.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.shared.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .colorScheme(.dark)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.shared.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Barber")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            TextField("Enter barber name", text: $barberName)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.shared.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Selected Services")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(ServiceType.allCases.filter { $0 != .other }, id: \.self) { service in
                                    ServiceCheckbox(
                                        service: service,
                                        isSelected: selectedServices.contains(service)
                                    ) {
                                        if selectedServices.contains(service) {
                                            selectedServices.remove(service)
                                        } else {
                                            selectedServices.insert(service)
                                        }
                                    }
                                }
                            }
                            
                            if !customServices.isEmpty {
                                VStack(spacing: 8) {
                                    ForEach(Array(customServices.enumerated()), id: \.offset) { index, serviceName in
                                        HStack {
                                            Image(systemName: "checkmark.square.fill")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(ColorManager.shared.accentOrange)
                                            
                                            Text(serviceName)
                                                .font(FontManager.playfairRegular(size: 14))
                                                .foregroundColor(ColorManager.shared.primaryText)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                customServices.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(ColorManager.shared.errorColor)
                                            }
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(ColorManager.shared.selectedBackground)
                                        )
                                    }
                                }
                            }
                            
                            Button(action: { showingCustomService = true }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(ColorManager.shared.accentOrange)
                                    
                                    Text("Add Custom Service")
                                        .font(FontManager.playfairMedium(size: 14))
                                        .foregroundColor(ColorManager.shared.accentOrange)
                                    
                                    Spacer()
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorManager.shared.accentOrange, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            TextField("Add a comment (optional)", text: $comment, axis: .vertical)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.shared.primaryText)
                                .lineLimit(3...6)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.shared.cardBackground)
                                )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Procedure")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.shared.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveProcedure()
                    }
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(ColorManager.shared.accentBlue)
                    .disabled(selectedServices.isEmpty && customServices.isEmpty)
                }
            }
            .alert("Add Custom Service", isPresented: $showingCustomService) {
                TextField("Service name", text: $customServiceName)
                Button("Add") {
                    if !customServiceName.trimmingCharacters(in: .whitespaces).isEmpty {
                        customServices.append(customServiceName.trimmingCharacters(in: .whitespaces))
                        customServiceName = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    customServiceName = ""
                }
            }
        }
    }
    
    private func saveProcedure() {
        var services: [Service] = []
        
        for serviceType in selectedServices where serviceType != .other {
            services.append(Service(type: serviceType))
        }
        
        for customName in customServices {
            services.append(Service(type: .other, customName: customName))
        }
        
        let updatedProcedure = Procedure(
            date: selectedDate,
            barberName: barberName,
            services: services,
            comment: comment
        )
        
        let finalProcedure = Procedure(
            date: updatedProcedure.date,
            barberName: updatedProcedure.barberName,
            services: updatedProcedure.services,
            comment: updatedProcedure.comment
        )
        
        dataManager.deleteProcedure(procedure)
        dataManager.addProcedure(finalProcedure)
        
        dismiss()
    }
}

#Preview {
    EditProcedureView(
        procedure: Procedure(
            date: Date(),
            barberName: "Alex",
            services: [
                Service(type: .haircut),
                Service(type: .shave)
            ],
            comment: "Great service!"
        ),
        dataManager: DataManager.shared
    )
}
