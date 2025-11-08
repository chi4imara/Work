import SwiftUI

struct AddMedicationView: View {
    let onSave: (Medication) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var selectedDaySchedule: DayScheduleType = .everyday
    @State private var customDays: Set<Medication.WeekDay> = []
    @State private var times: [String] = ["08:00"]
    @State private var startDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Date()
    @State private var comment = ""
    
    @State private var showingTimePickerIndex: Int? = nil
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medication Name *")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Enter medication name", text: $name)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dosage")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("e.g., 1 tablet, 5 ml", text: $dosage)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Days of Intake")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            VStack(spacing: 10) {
                                ForEach(DayScheduleType.allCases, id: \.self) { scheduleType in
                                    HStack {
                                        Button(action: {
                                            selectedDaySchedule = scheduleType
                                            updateCustomDays()
                                        }) {
                                            HStack {
                                                Image(systemName: selectedDaySchedule == scheduleType ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(selectedDaySchedule == scheduleType ? AppColors.accentBlue : AppColors.cardSecondaryText)
                                                
                                                Text(scheduleType.rawValue)
                                                    .font(AppFonts.callout())
                                                    .foregroundColor(AppColors.cardText)
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if selectedDaySchedule == .custom {
                                customDaysView
                            }
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Intake Times *")
                                    .font(AppFonts.callout())
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.cardText)
                                
                                Spacer()
                                
                                Button("Add Time") {
                                    times.append("12:00")
                                }
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.accentBlue)
                            }
                            
                            ForEach(times.indices, id: \.self) { index in
                                HStack {
                                    Button(times[index]) {
                                        showingTimePickerIndex = index
                                    }
                                    .font(AppFonts.callout())
                                    .foregroundColor(AppColors.accentBlue)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(AppColors.accentBlue.opacity(0.1))
                                    .clipShape(Capsule())
                                    
                                    Spacer()
                                    
                                    if times.count > 1 {
                                        Button(action: {
                                            times.remove(at: index)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Treatment Period")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            VStack(spacing: 15) {
                                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                                    .font(AppFonts.callout())
                                    .foregroundColor(AppColors.cardText)
                                
                                HStack {
                                    Button(action: {
                                        hasEndDate.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: hasEndDate ? "checkmark.square.fill" : "square")
                                                .foregroundColor(hasEndDate ? AppColors.accentBlue : AppColors.cardSecondaryText)
                                            
                                            Text("Set End Date")
                                                .font(AppFonts.callout())
                                                .foregroundColor(AppColors.cardText)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                if hasEndDate {
                                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                                        .font(AppFonts.callout())
                                        .foregroundColor(AppColors.cardText)
                                }
                            }
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("e.g., after meals", text: $comment, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("New Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { showingTimePickerIndex != nil },
            set: { if !$0 { showingTimePickerIndex = nil } }
        )) {
            if let index = showingTimePickerIndex {
                TimePickerSheet(
                    selectedTime: Binding(
                        get: { times[index] },
                        set: { times[index] = $0 }
                    )
                )
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            updateCustomDays()
        }
    }
    
    private var customDaysView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select specific days:")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.cardSecondaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(Medication.WeekDay.allCases, id: \.self) { day in
                    Button(action: {
                        if customDays.contains(day) {
                            customDays.remove(day)
                        } else {
                            customDays.insert(day)
                        }
                    }) {
                        HStack {
                            Image(systemName: customDays.contains(day) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(customDays.contains(day) ? AppColors.accentBlue : AppColors.cardSecondaryText)
                            
                            Text(day.rawValue)
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.cardText)
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.top, 10)
    }
    
    private func updateCustomDays() {
        switch selectedDaySchedule {
        case .everyday:
            customDays = Set(Medication.WeekDay.allCases)
        case .weekdays:
            customDays = [.monday, .tuesday, .wednesday, .thursday, .friday]
        case .weekends:
            customDays = [.saturday, .sunday]
        case .custom:
            break
        }
    }
    
    private func saveMedication() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter medication name"
            showingError = true
            return
        }
        
        guard !times.isEmpty else {
            errorMessage = "Please add at least one intake time"
            showingError = true
            return
        }
        
        guard !customDays.isEmpty else {
            errorMessage = "Please select at least one day"
            showingError = true
            return
        }
        
        if hasEndDate && endDate < startDate {
            errorMessage = "End date must be after start date"
            showingError = true
            return
        }
        
        let medication = Medication(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            dosage: dosage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "1 dose" : dosage.trimmingCharacters(in: .whitespacesAndNewlines),
            days: Array(customDays),
            times: times,
            startDate: startDate,
            endDate: hasEndDate ? endDate : nil,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        onSave(medication)
        dismiss()
    }
}

struct TimePickerItem: Identifiable {
    let id = UUID()
    let index: Int
}

struct TimePickerSheet: View {
    @Binding var selectedTime: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedHour = 8
    @State private var selectedMinute = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 10) {
                        Text("Select Time")
                            .font(AppFonts.title2())
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Choose medication time")
                            .font(AppFonts.callout())
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .frame(height: 80)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Text(String(format: "%02d:%02d", selectedHour, selectedMinute))
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(AppColors.accentBlue)
                    }
                    .padding(.horizontal, 40)
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 10) {
                            Text("Hour")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.cardText)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .frame(width: 100, height: 150)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Picker("Hour", selection: $selectedHour) {
                                    ForEach(0..<24, id: \.self) { hour in
                                        Text(String(format: "%02d", hour))
                                            .font(.system(size: 20, weight: .medium))
                                            .tag(hour)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 130)
                            }
                        }
                        
                        Text(":")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.top, 40)
                        
                        VStack(spacing: 10) {
                            Text("Minute")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.cardText)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .frame(width: 100, height: 150)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Picker("Minute", selection: $selectedMinute) {
                                    ForEach(Array(stride(from: 0, to: 60, by: 5)), id: \.self) { minute in
                                        Text(String(format: "%02d", minute))
                                            .font(.system(size: 20, weight: .medium))
                                            .tag(minute)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 130)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(AppColors.secondaryButton)
                                .cornerRadius(12)
                        }
                        
                        Button {
                            selectedTime = String(format: "%02d:%02d", selectedHour, selectedMinute)
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(AppFonts.callout())
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(AppColors.accentBlue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            parseCurrentTime()
        }
    }
    
    private func parseCurrentTime() {
        let components = selectedTime.split(separator: ":").compactMap { Int($0) }
        if components.count == 2 {
            selectedHour = components[0]
            selectedMinute = components[1]
        }
    }
}

#Preview {
    AddMedicationView { medication in
        print("Saved medication: \(medication.name)")
    }
}
