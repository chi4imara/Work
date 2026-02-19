import SwiftUI

struct AddProcedureView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedDate = Date()
    @State private var barberName = ""
    @State private var selectedServices: Set<ServiceType> = []
    @State private var customServices: [String] = []
    @State private var customServiceName = ""
    @State private var comment = ""
    @State private var showingCustomService = false
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Procedure")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    Spacer()
                    
                    Button {
                        saveProcedure()
                    } label: {
                        Text("Save")
                            .font(FontManager.playfairSemiBold(size: 32))
                            .foregroundColor(ColorManager.shared.accentBlue)
                    }
                    .disabled(selectedServices.isEmpty && customServices.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
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
    
    private func saveProcedure() {
        var services: [Service] = []
        
        for serviceType in selectedServices where serviceType != .other {
            services.append(Service(type: serviceType))
        }
        
        for customName in customServices {
            services.append(Service(type: .other, customName: customName))
        }
        
        let procedure = Procedure(
            date: selectedDate,
            barberName: barberName,
            services: services,
            comment: comment
        )
        
        dataManager.addProcedure(procedure)
        
        selectedDate = Date()
        barberName = ""
        selectedServices = []
        customServices = []
        comment = ""
        
        withAnimation {
            selectedTab = .journal
        }
    }
}

struct ServiceCheckbox: View {
    let service: ServiceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.shared.accentBlue : ColorManager.shared.secondaryText)
                
                Text(service.rawValue)
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorManager.shared.selectedBackground : ColorManager.shared.cardBackground)
            )
        }
    }
}

