import SwiftUI

struct TodayView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appColors = AppColors.shared
    @State private var selectedWeather: WeatherType?
    @State private var selectedMood: MoodType?
    @State private var temperature: String = ""
    @State private var location: String = ""
    @State private var tag: String = ""
    @State private var comment: String = ""
    @State private var showingSaveMessage = false
    @State private var errorMessage: String?
    
    @Binding var selectedTab: Int
    
    var body: some View {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        dayLocationSection
                        
                        weatherSection
                        
                        moodSection
                        
                        commentSection
                        
                        actionButtons
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .onAppear {
                loadTodayEntry()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
            .overlay(
                saveMessageOverlay,
                alignment: .top
            )
        }
    
    private var headerSection: some View {
        HStack {
            Text("Today")
                .font(.builderSans(.bold, size: 28))
                .foregroundColor(appColors.textPrimary)
            
            Spacer()
            
            Button {
                selectedTab = 1
            } label: {
                Text("Journal")
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(appColors.primaryOrange)
            }
        }
    }
    
    private var dayLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today, \(Date().formatted(date: .abbreviated, time: .omitted))")
                .font(.builderSans(.medium, size: 18))
                .foregroundColor(appColors.textPrimary)
            
            TextField("City, place...", text: $location)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.selectedScheme == .dark ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather")
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
                TextField("0", text: $temperature)
                    .font(.builderSans(.medium, size: 18))
                    .foregroundColor(appColors.selectedScheme == .dark ? .white : .black)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(appColors.cardGradient)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                    )
                
                Text("°C")
                    .font(.builderSans(.medium, size: 18))
                    .foregroundColor(appColors.textSecondary)
                
                Spacer()
            }
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood")
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
                .foregroundColor(appColors.selectedScheme == .dark ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            TextField("How was your day?", text: $comment, axis: .vertical)
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.selectedScheme == .dark ? .white : .black)
                .lineLimit(5, reservesSpace: true)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(appColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(appColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: saveEntry) {
                Text("Save")
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(canSave ? AnyShapeStyle(appColors.buttonGradient) : AnyShapeStyle(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.5)))
                    .cornerRadius(28)
            }
            .disabled(!canSave)
            
            HStack(spacing: 16) {
                if let todayEntry = dataManager.getTodayEntry() {
                    NavigationLink(destination: EntryDetailView(entry: todayEntry)) {
                        Text("Details")
                            .font(.builderSans(.medium, size: 16))
                            .foregroundColor(appColors.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(appColors.cardGradient)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(appColors.primaryBlue.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                
                Button(action: clearFields) {
                    Text("Clear")
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(appColors.cardGradient)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(appColors.textSecondary.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    private var saveMessageOverlay: some View {
        Group {
            if showingSaveMessage {
                Text("Saved!")
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(appColors.accentGreen)
                    .cornerRadius(20)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showingSaveMessage = false
                            }
                        }
                    }
            }
        }
    }
    
    private var canSave: Bool {
        guard let weather = selectedWeather,
              let mood = selectedMood,
              let temp = Double(temperature),
              temp >= -60 && temp <= 60 else {
            return false
        }
        
        return tag.count <= 30 && comment.count <= 500 && location.count <= 60
    }
    
    private func loadTodayEntry() {
        if let entry = dataManager.getTodayEntry() {
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
        
        let entry = MoodEntry(
            date: Date(),
            time: Date(),
            weather: weather,
            temperature: temp,
            mood: mood,
            location: location.isEmpty ? nil : location,
            tag: tag.isEmpty ? nil : tag,
            comment: comment.isEmpty ? nil : comment
        )
        
        dataManager.addEntry(entry)
        
        withAnimation {
            showingSaveMessage = true
        }
    }
    
    private func clearFields() {
        selectedWeather = nil
        selectedMood = nil
        temperature = ""
        location = ""
        tag = ""
        comment = ""
    }
}

struct WeatherChip: View {
    let weather: WeatherType
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: weather.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : appColors.primaryBlue)
                
                Text(weather.displayName)
                    .font(.builderSans(.medium, size: 12))
                    .foregroundColor(isSelected ? .white : appColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? appColors.primaryGradient : appColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? appColors.primaryBlue : appColors.primaryBlue.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct MoodChip: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: mood.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : appColors.primaryOrange)
                
                Text(mood.displayName)
                    .font(.builderSans(.medium, size: 10))
                    .foregroundColor(isSelected ? .white : appColors.textSecondary)
            }
            .frame(width: 60, height: 70)
            .background(isSelected ? appColors.buttonGradient : appColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? appColors.primaryOrange : appColors.primaryBlue.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

