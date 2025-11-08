import SwiftUI

struct EditEntry: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appColors = AppColors.shared
    @Environment(\.presentationMode) var presentationMode
    
    let entry: MoodEntry?
    let prefilledDate: Date?
    
    @State private var selectedDate: Date
    @State private var selectedTime: Date?
    @State private var selectedWeather: WeatherType?
    @State private var selectedMood: MoodType?
    @State private var temperature: String = ""
    @State private var location: String = ""
    @State private var tag: String = ""
    @State private var comment: String = ""
    @State private var errorMessage: String?
    @State private var showingTimePicker = false
    
    init(entry: MoodEntry? = nil, prefilledDate: Date? = nil) {
        self.entry = entry
        self.prefilledDate = prefilledDate
        self._selectedDate = State(initialValue: entry?.date ?? prefilledDate ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        dateTimeSection
                        
                        locationSection
                        
                        weatherSection
                        
                        moodSection
                        
                        commentSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(appColors.selectedScheme == .dark ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(appColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(canSave ? appColors.primaryBlue : appColors.textSecondary)
                    .disabled(!canSave)
                }
            }
            .onAppear {
                loadEntryData()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date & Time")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .font(.builderSans(.medium, size: 16))
                .foregroundColor(appColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 1)
                }
                .cornerRadius(12)
            
            HStack {
                Button(action: {
                    if selectedTime == nil {
                        selectedTime = Date()
                    } else {
                        selectedTime = nil
                    }
                }) {
                    HStack {
                        Image(systemName: selectedTime == nil ? "square" : "checkmark.square.fill")
                            .foregroundColor(appColors.primaryBlue)
                        
                        Text("Include time")
                            .font(.builderSans(.medium, size: 16))
                            .foregroundColor(appColors.textPrimary)
                        
                        Spacer()
                    }
                }
                
                if let time = selectedTime {
                    DatePicker("", selection: Binding(
                        get: { time },
                        set: { selectedTime = $0 }
                    ), displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(appColors.cardGradient)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 1)
            }
            .cornerRadius(12)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location (optional)")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            TextField("City, place...", text: $location)
                .font(.builderSans(.regular, size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(location.count > 60 ? Color.red : appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
            
            if location.count > 60 {
                Text("Location must be 60 characters or less")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(.red)
            }
        }
    }
    
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather *")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(WeatherType.allCases, id: \.self) { weather in
                    WeatherChip(
                        weather: weather,
                        isSelected: selectedWeather == weather
                    ) {
                        selectedWeather = weather
                    }
                }
            }
            
            HStack {
                TextField("Temperature", text: $temperature)
                    .font(.builderSans(.medium, size: 18))
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(appColors.cardGradient)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isValidTemperature ? appColors.primaryBlue.opacity(0.2) : Color.red, lineWidth: 1)
                    )
                
                Text("°C")
                    .font(.builderSans(.medium, size: 18))
                    .foregroundColor(appColors.textSecondary)
                
                Spacer()
            }
            
            if !isValidTemperature && !temperature.isEmpty {
                Text("Temperature must be between -60°C and +60°C")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(.red)
            }
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood *")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    MoodChip(
                        mood: mood,
                        isSelected: selectedMood == mood
                    ) {
                        selectedMood = mood
                    }
                }
            }
            
            TextField("Why? (optional)", text: $tag)
                .font(.builderSans(.regular, size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(tag.count > 30 ? Color.red : appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
            
            if tag.count > 30 {
                Text("Tag must be 30 characters or less")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(.red)
            }
        }
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment (optional)")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            TextField("How was your day?", text: $comment, axis: .vertical)
                .font(.builderSans(.regular, size: 16))
                .lineLimit(5, reservesSpace: true)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(comment.count > 500 ? Color.red : appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
            
            HStack {
                Spacer()
                Text("\(comment.count)/500")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(comment.count > 500 ? .red : appColors.textSecondary)
            }
        }
    }
    
    private var isValidTemperature: Bool {
        guard let temp = Double(temperature) else { return temperature.isEmpty }
        return temp >= -60 && temp <= 60
    }
    
    private var canSave: Bool {
        guard selectedWeather != nil,
              selectedMood != nil,
              isValidTemperature,
              !temperature.isEmpty else {
            return false
        }
        
        return tag.count <= 30 && comment.count <= 500 && location.count <= 60
    }
    
    private func loadEntryData() {
        if let entry = entry {
            selectedDate = entry.date
            selectedTime = entry.time
            selectedWeather = entry.weather
            selectedMood = entry.mood
            temperature = String(entry.temperature)
            location = entry.location ?? ""
            tag = entry.tag ?? ""
            comment = entry.comment ?? ""
        }
    }
    
    private func saveEntry() {
        guard let weather = selectedWeather else {
            errorMessage = "Select weather"
            return
        }
        
        guard let mood = selectedMood else {
            errorMessage = "Select mood"
            return
        }
        
        guard let temp = Double(temperature), temp >= -60 && temp <= 60 else {
            errorMessage = "Invalid temperature"
            return
        }
        
        let newEntry = MoodEntry(
            date: selectedDate,
            time: selectedTime,
            weather: weather,
            temperature: temp,
            mood: mood,
            location: location.isEmpty ? nil : location,
            tag: tag.isEmpty ? nil : tag,
            comment: comment.isEmpty ? nil : comment
        )
        
        if let existingEntry = entry {
            var updatedEntry = newEntry
            dataManager.deleteEntry(existingEntry)
            dataManager.addEntry(updatedEntry)
        } else {
            dataManager.addEntry(newEntry)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

