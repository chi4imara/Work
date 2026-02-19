import SwiftUI

struct SleepEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var bedtime = Calendar.current.date(byAdding: .hour, value: -8, to: Date()) ?? Date()
    @State private var wakeTime = Date()
    @State private var quality = 3
    
    let onSave: (Date, Date, Int) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "bed.double")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.iconAccent)
                            
                            Text("Sleep Entry")
                                .font(AppFonts.title2())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Track your sleep for better energy")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, AppSpacing.lg)
                        
                        VStack(spacing: AppSpacing.md) {
                            EntryCard(title: "Bedtime", icon: "moon") {
                                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                            }
                            
                            EntryCard(title: "Wake Time", icon: "sun.max") {
                                DatePicker("", selection: $wakeTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                            }
                            
                            EntryCard(title: "Sleep Quality", icon: "star") {
                                VStack(spacing: AppSpacing.sm) {
                                    HStack {
                                        ForEach(1...5, id: \.self) { rating in
                                            Button(action: { quality = rating }) {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(rating <= quality ? AppColors.iconAccent : AppColors.textTertiary.opacity(0.3))
                                            }
                                        }
                                    }
                                    
                                    Text(qualityText)
                                        .font(AppFonts.caption())
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                        }
                        
                        if wakeTime > bedtime {
                            let duration = wakeTime.timeIntervalSince(bedtime) / 3600
                            Text("Duration: \(String(format: "%.1f", duration)) hours")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.iconAccent)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppCornerRadius.md)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(bedtime, wakeTime, quality)
                        dismiss()
                    }
                    .foregroundColor(AppColors.iconAccent)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private var qualityText: String {
        switch quality {
        case 1: return "Poor"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Very Good"
        case 5: return "Excellent"
        default: return "Good"
        }
    }
}

struct MealEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedType: MealType = .breakfast
    @State private var mealName = ""
    @State private var healthRating = 3
    
    let onSave: (MealType, String, Int) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "leaf")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.iconAccent)
                            
                            Text("Meal Entry")
                                .font(AppFonts.title2())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Track your nutrition mindfully")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, AppSpacing.lg)
                        
                        VStack(spacing: AppSpacing.md) {
                            EntryCard(title: "Meal Type", icon: "clock") {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                                    ForEach(MealType.allCases, id: \.self) { type in
                                        Button(action: { selectedType = type }) {
                                            HStack {
                                                Image(systemName: type.icon)
                                                Text(type.rawValue)
                                                    .font(AppFonts.callout())
                                            }
                                            .foregroundColor(selectedType == type ? AppColors.iconSecondary : AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, AppSpacing.sm)
                                            .background(
                                                selectedType == type ? 
                                                AppColors.iconAccent : 
                                                AppColors.cardBackground
                                            )
                                            .cornerRadius(AppCornerRadius.sm)
                                        }
                                    }
                                }
                            }
                            
                            EntryCard(title: "What did you eat?", icon: "fork.knife") {
                                TextField("Enter meal name", text: $mealName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            EntryCard(title: "How healthy was it?", icon: "heart") {
                                VStack(spacing: AppSpacing.sm) {
                                    HStack {
                                        ForEach(1...5, id: \.self) { rating in
                                            Button(action: { healthRating = rating }) {
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(rating <= healthRating ? AppColors.lightGreen : AppColors.textTertiary.opacity(0.3))
                                            }
                                        }
                                    }
                                    
                                    Text(healthText)
                                        .font(AppFonts.caption())
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(selectedType, mealName.isEmpty ? selectedType.rawValue : mealName, healthRating)
                        dismiss()
                    }
                    .foregroundColor(AppColors.iconAccent)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private var healthText: String {
        switch healthRating {
        case 1: return "Not very healthy"
        case 2: return "Could be better"
        case 3: return "Decent choice"
        case 4: return "Great choice!"
        case 5: return "Excellent choice!"
        default: return "Decent choice"
        }
    }
}

struct ActivityEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedType: ActivityType = .walk
    @State private var activityName = ""
    @State private var duration: Double = 30
    
    let onSave: (ActivityType, String, TimeInterval) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "figure.run")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.iconAccent)
                            
                            Text("Activity Entry")
                                .font(AppFonts.title2())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Movement brings energy and joy")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, AppSpacing.lg)
                        
                        VStack(spacing: AppSpacing.md) {
                            EntryCard(title: "Activity Type", icon: "list.bullet") {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                                    ForEach(ActivityType.allCases, id: \.self) { type in
                                        Button(action: { 
                                            selectedType = type
                                            if activityName.isEmpty {
                                                activityName = type.rawValue
                                            }
                                        }) {
                                            VStack(spacing: AppSpacing.xs) {
                                                Image(systemName: type.icon)
                                                    .font(.system(size: 20))
                                                Text(type.rawValue)
                                                    .font(AppFonts.caption())
                                            }
                                            .foregroundColor(selectedType == type ? AppColors.iconSecondary : AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, AppSpacing.sm)
                                            .background(
                                                selectedType == type ? 
                                                AppColors.iconAccent : 
                                                AppColors.cardBackground
                                            )
                                            .cornerRadius(AppCornerRadius.sm)
                                        }
                                    }
                                }
                            }
                            
                            EntryCard(title: "Activity Name", icon: "pencil") {
                                TextField("Enter activity name", text: $activityName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            EntryCard(title: "Duration", icon: "clock") {
                                VStack(spacing: AppSpacing.sm) {
                                    HStack {
                                        Text("\(Int(duration)) minutes")
                                            .font(AppFonts.headline())
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Spacer()
                                    }
                                    
                                    Slider(value: $duration, in: 5...120, step: 5)
                                        .tint(AppColors.iconAccent)
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let finalName = activityName.isEmpty ? selectedType.rawValue : activityName
                        onSave(selectedType, finalName, duration * 60)
                        dismiss()
                    }
                    .foregroundColor(AppColors.iconAccent)
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            activityName = selectedType.rawValue
        }
    }
}

struct EntryCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.iconAccent)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            content
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppFonts.body())
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.sm)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
    }
}

#Preview("Sleep Entry") {
    SleepEntryView { _, _, _ in }
}

#Preview("Meal Entry") {
    MealEntryView { _, _, _ in }
}

#Preview("Activity Entry") {
    ActivityEntryView { _, _, _ in }
}
