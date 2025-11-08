import SwiftUI

struct TripFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    
    let trip: Trip?
    
    @State private var title = ""
    @State private var country = ""
    @State private var city = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var places: [String] = [""]
    @State private var impressions: [Impression] = []
    
    @State private var showingDeleteAlert = false
    @State private var showingCancelAlert = false
    
    private var isEditing: Bool {
        trip != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        startDate <= endDate
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Basic Information")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            CustomTextField(title: "Trip Name", text: $title, isRequired: true)
                            CustomTextField(title: "Country", text: $country, isRequired: true)
                            CustomTextField(title: "City (Optional)", text: $city)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Dates")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Places Visited")
                                    .font(FontManager.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                Button(action: addPlace) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(ColorTheme.primaryText)
                                }
                            }
                            
                            ForEach(places.indices, id: \.self) { index in
                                HStack {
                                    CustomTextField(
                                        title: "Place \(index + 1)",
                                        text: Binding(
                                            get: { places[index] },
                                            set: { places[index] = $0 }
                                        )
                                    )
                                    
                                    if places.count > 1 {
                                        Button(action: { removePlace(at: index) }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(ColorTheme.error)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Notes")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            CustomTextEditor(text: $notes, placeholder: "Share your travel memories...")
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Impressions")
                                    .font(FontManager.headline)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                Button(action: addImpression) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(ColorTheme.primaryText)
                                }
                            }
                            
                            ForEach(impressions.indices, id: \.self) { index in
                                HStack {
                                    CustomTextField(
                                        title: "Impression \(index + 1)",
                                        text: Binding(
                                            get: { impressions[index].text },
                                            set: { impressions[index].text = $0 }
                                        )
                                    )
                                    
                                    Button(action: { removeImpression(at: index) }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(ColorTheme.error)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Trip" : "New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if hasUnsavedChanges() {
                        showingCancelAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: HStack {
                    if isEditing {
                        Button("Delete") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(ColorTheme.error)
                    }
                    
                    Button("Save") {
                        saveTrip()
                    }
                    .disabled(!canSave)
                    .foregroundColor(canSave ? ColorTheme.primaryText : ColorTheme.borderColor)
                }
            )
        }
        .onAppear {
            setupForm()
        }
        .alert("Archive Trip", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let trip = trip {
                    dataManager.archiveTrip(trip)
                }
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This trip information will be permanently deleted.")
        }
        .alert("Discard Changes", isPresented: $showingCancelAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    private func setupForm() {
        if let trip = trip {
            title = trip.title
            country = trip.country
            city = trip.city ?? ""
            startDate = trip.startDate
            endDate = trip.endDate
            notes = trip.notes
            places = trip.places.isEmpty ? [""] : trip.places
            impressions = trip.impressions
        }
    }
    
    private func addPlace() {
        places.append("")
    }
    
    private func removePlace(at index: Int) {
        places.remove(at: index)
    }
    
    private func addImpression() {
        impressions.append(Impression(text: ""))
    }
    
    private func removeImpression(at index: Int) {
        impressions.remove(at: index)
    }
    
    private func saveTrip() {
        let cleanedPlaces = places.compactMap { place in
            let trimmed = place.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        
        let cleanedImpressions = impressions.compactMap { impression in
            let trimmed = impression.text.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : Impression(text: trimmed, createdAt: impression.createdAt)
        }
        
        if let existingTrip = trip {
            var updatedTrip = existingTrip
            updatedTrip.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedTrip.country = country.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedTrip.city = city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : city.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedTrip.startDate = startDate
            updatedTrip.endDate = endDate
            updatedTrip.notes = notes
            updatedTrip.places = cleanedPlaces
            updatedTrip.impressions = cleanedImpressions
            
            dataManager.updateTrip(updatedTrip)
        } else {
            let newTrip = Trip(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                country: country.trimmingCharacters(in: .whitespacesAndNewlines),
                city: city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : city.trimmingCharacters(in: .whitespacesAndNewlines),
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                places: cleanedPlaces,
                impressions: cleanedImpressions
            )
            
            dataManager.addTrip(newTrip)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func hasUnsavedChanges() -> Bool {
        if let trip = trip {
            return title != trip.title ||
                   country != trip.country ||
                   city != (trip.city ?? "") ||
                   startDate != trip.startDate ||
                   endDate != trip.endDate ||
                   notes != trip.notes ||
                   places != trip.places ||
                   impressions.count != trip.impressions.count
        } else {
            return !title.isEmpty || !country.isEmpty || !city.isEmpty || !notes.isEmpty || places.count > 1 || !impressions.isEmpty
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var isRequired: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(ColorTheme.error)
                }
            }
            
            TextField("Enter \(title)", text: $text)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                )
        }
    }
}

struct CustomTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
                .frame(minHeight: 100)
            
            if text.isEmpty {
                Text(placeholder)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(ColorTheme.cardBackground)
                .scrollContentBackground(.hidden)
                .cornerRadius(8)
        }
    }
}

#Preview {
    TripFormView(trip: nil)
}

