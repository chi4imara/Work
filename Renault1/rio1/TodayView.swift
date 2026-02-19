import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: AppDataStore
    @State private var moodNote = ""
    @State private var selectedMood: Mood?
    @State private var showingAddRitual = false
    @State private var showMicroSupport = false
    @State private var supportMessage = ""
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var progressPercentage: Double {
        store.todayEntry?.completionPercentage ?? 0.0
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HeaderSection(greeting: greeting)
                    
                    ProgressSection(progress: progressPercentage)
                    
                    MoodSection(
                        selectedMood: store.todayEntry?.mood,
                        onMoodSelected: { mood in
                            moodNote = ""
                            selectedMood = mood
                        }
                    )
                    
                    RitualsSection(
                        rituals: store.rituals,
                        completedRituals: store.todayEntry?.completedRituals ?? [],
                        onRitualToggled: toggleRitual,
                        onAddRitual: { showingAddRitual = true }
                    )
                    
                    if let challenge = store.todayChallenge {
                        ChallengeSection(
                            challenge: challenge,
                            isCompleted: store.todayEntry?.completedChallenges.contains(challenge.id) ?? false,
                            onChallengeCompleted: { completeChallenge(challenge) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .sheet(item: $selectedMood) { mood in
            MoodNoteSheet(
                mood: mood,
                note: $moodNote,
                onSave: { mood, note in
                    saveMood(mood, note: note)
                    moodNote = ""
                }
            )
        }
        .sheet(isPresented: $showingAddRitual) {
            AddRitualSheet { ritual in
                store.addRitual(ritual)
                showSupportMessage("Great! Your inner balance is growing!")
            }
        }
    }
    
    private func toggleRitual(_ ritual: Ritual) {
        guard var todayEntry = store.todayEntry else { return }
        
        if todayEntry.completedRituals.contains(ritual.id) {
            todayEntry.completedRituals.remove(ritual.id)
        } else {
            todayEntry.completedRituals.insert(ritual.id)
            showSupportMessage("Excellent! Your inner balance is growing!")
        }
        
        store.setTodayEntry(todayEntry)
    }
    
    private func completeChallenge(_ challenge: Challenge) {
        guard var todayEntry = store.todayEntry else { return }
        todayEntry.completedChallenges.insert(challenge.id)
        store.setTodayEntry(todayEntry)
        showSupportMessage("You're taking care of yourself! Amazing!")
    }
    
    private func saveMood(_ mood: Mood, note: String) {
        guard var todayEntry = store.todayEntry else { return }
        todayEntry.mood = mood
        todayEntry.note = note
        store.setTodayEntry(todayEntry)
        showSupportMessage("Thank you for noting your state!")
    }
    
    private func showSupportMessage(_ message: String) {
        supportMessage = message
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showMicroSupport = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showMicroSupport = false
            }
        }
    }
}

struct HeaderSection: View {
    let greeting: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text("How are you feeling today?")
                        .font(FontManager.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.text.opacity(0.7))
                }
                Spacer()
            }
        }
        .padding(.top, 20)
    }
}

struct ProgressSection: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.lightGray)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, progress * geometry.size.width), height: 8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct MoodSection: View {
    let selectedMood: Mood?
    let onMoodSelected: (Mood) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mood")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                if let mood = selectedMood {
                    HStack(spacing: 6) {
                        Text(mood.emoji)
                            .font(.system(size: 20))
                        Text(mood.name)
                            .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                            .foregroundColor(AppColors.text)
                    }
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(Mood.allMoods) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMood?.id == mood.id,
                        action: { onMoodSelected(mood) }
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                action()
            }
        }) {
            VStack(spacing: 6) {
                Text(mood.emoji)
                    .font(.system(size: 28))
                
                Text(mood.name)
                    .font(FontManager.playfairDisplay(size: 12))
                    .foregroundColor(AppColors.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? mood.color.opacity(0.2) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? mood.color : AppColors.lightGray, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct RitualsSection: View {
    let rituals: [Ritual]
    let completedRituals: Set<UUID>
    let onRitualToggled: (Ritual) -> Void
    let onAddRitual: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mini-Rituals")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button(action: onAddRitual) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            if rituals.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary.opacity(0.5))
                    
                    Text("Add your first ritual and start taking care of yourself")
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.text.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            } else {
                ForEach(rituals) { ritual in
                    RitualRow(
                        ritual: ritual,
                        isCompleted: completedRituals.contains(ritual.id),
                        onToggle: { onRitualToggled(ritual) }
                    )
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct RitualRow: View {
    let ritual: Ritual
    let isCompleted: Bool
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    onToggle()
                    isAnimating = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isCompleted ? AppColors.success : AppColors.lightGray)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ritual.title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.text)
                    .strikethrough(isCompleted)
                
                if !ritual.description.isEmpty {
                    Text(ritual.description)
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.text.opacity(0.6))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: ritual.category.icon)
                    .font(.system(size: 12))
                Text(ritual.category.rawValue)
                    .font(FontManager.playfairDisplay(size: 12))
            }
            .foregroundColor(ritual.category.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(ritual.category.color.opacity(0.1))
            )
        }
        .padding(.vertical, 8)
    }
}

struct ChallengeSection: View {
    let challenge: Challenge
    let isCompleted: Bool
    let onChallengeCompleted: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mini-Challenge of the Day")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(challenge.title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Text(challenge.description)
                    .font(FontManager.playfairDisplay(size: 14))
                    .foregroundColor(AppColors.text.opacity(0.7))
                    .lineSpacing(2)
                
                if !isCompleted {
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            onChallengeCompleted()
                        }
                    }) {
                        Text("I did it!")
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.secondary, AppColors.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.success)
                        Text("Completed!")
                            .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(AppColors.success)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct MicroSupportOverlay: View {
    let message: String
    let onDismiss: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text(message)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
            
            Spacer().frame(height: 120)
        }
        .padding(.horizontal, 20)
    }
}

struct MoodNoteSheet: View {
    let mood: Mood?
    @Binding var note: String
    let onSave: (Mood, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let mood = mood {
                    VStack(spacing: 16) {
                        Text(mood.emoji)
                            .font(.system(size: 80))
                        
                        Text("You're feeling \(mood.name.lowercased())")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.text)
                    }
                    .padding(.top, 20)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add a note (optional)")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    TextField("What's on your mind?", text: $note, axis: .vertical)
                        .font(FontManager.playfairDisplay(size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                Spacer()
                
                Button(action: {
                    if let mood = mood {
                        onSave(mood, note)
                    }
                    dismiss()
                }) {
                    Text("Save")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(AppColors.backgroundGradient)
            .navigationTitle("Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

struct AddRitualSheet: View {
    let onSave: (Ritual) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = RitualCategory.mindfulness
    @State private var selectedFrequency = RitualFrequency.daily
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Title")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    TextField("Enter ritual name", text: $title)
                        .font(FontManager.playfairDisplay(size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Category")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RitualCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Frequency")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(RitualFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description (optional)")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    TextField("Why is this important?", text: $description, axis: .vertical)
                        .font(FontManager.playfairDisplay(size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(2...4)
                }
                
                Spacer()
                
                Button(action: {
                    let ritual = Ritual(
                        title: title,
                        category: selectedCategory,
                        frequency: selectedFrequency,
                        description: description
                    )
                    onSave(ritual)
                    dismiss()
                }) {
                    Text("Save")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0)
            }
            .padding(20)
            .background(AppColors.backgroundGradient)
            .navigationTitle("New Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(AppDataStore())
}
