import SwiftUI

struct MainView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var selectedColor: MoodColor?
    @State private var description: String = ""
    @State private var showingMenu = false
    @State private var showingSaveConfirmation = false
    @State private var showingEditView: IdentifiableID<DayEntry.ID>?
    @State private var todayEntry: DayEntry?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        if let entry = todayEntry {
                            savedDayView(entry: entry)
                        } else {
                            colorSelectionView
                            descriptionView
                            saveButtonView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadTodayEntry()
            }
            .onChange(of: dataManager.dayEntries) { _ in
                loadTodayEntry()
            }
            .alert("Day Saved", isPresented: $showingSaveConfirmation) {
                Button("OK") { }
            } message: {
                Text("Your mood color has been saved for today!")
            }
            .sheet(item: $showingEditView) { identifiableId in
                if let entry = dataManager.dayEntries.first(where: { $0.id == identifiableId.wrappedId }) {
                    EditDayView(entry: entry)
                }
            }
            .sheet(isPresented: $showingMenu) {
                MenuView(selectedTab: $selectedTab)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Color of the Day")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(colorTheme.primaryWhite)
            
            Spacer()
            
            Button(action: {
                showingMenu = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                    .frame(width: 44, height: 44)
                    .background(colorTheme.primaryPurple.opacity(0.3))
                    .clipShape(Circle())
            }
        }
    }
    
    private var colorSelectionView: some View {
        VStack(spacing: 20) {
            Text("What color reflects your mood today?")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                ForEach(colorTheme.moodColors) { color in
                    Button(action: {
                        selectedColor = color
                    }) {
                        ZStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            selectedColor?.id == color.id ? colorTheme.primaryWhite : Color.clear,
                                            lineWidth: 3
                                        )
                                )
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            if selectedColor?.id == color.id {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(colorTheme.primaryWhite)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            if let selected = selectedColor {
                Text("Today's color — \(selected.name)")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                    .padding(.top, 10)
            }
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Why this color? What do you feel?")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
            
            TextEditor(text: $description)
                .font(.playfairDisplay(14))
                .padding(12)
                .background(colorTheme.primaryWhite.opacity(0.9))
                .cornerRadius(12)
                .frame(minHeight: 100)
                .disabled(selectedColor == nil)
                .opacity(selectedColor == nil ? 0.5 : 1.0)
                .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
    }
    
    private var saveButtonView: some View {
        Button(action: saveDayEntry) {
            Text("Save Day")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(canSave ? colorTheme.primaryPurple : colorTheme.mediumGray)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(canSave ? colorTheme.primaryWhite : colorTheme.lightGray)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .disabled(!canSave)
        .padding(.horizontal)
    }
    
    private func savedDayView(entry: DayEntry) -> some View {
        VStack(spacing: 30) {
            Spacer()
            
            Circle()
                .fill(entry.color.color)
                .frame(width: 150, height: 150)
                .overlay(
                    Circle()
                        .stroke(colorTheme.primaryWhite, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.3), value: entry.color.color)
            
            VStack(spacing: 15) {
                Text(entry.description)
                    .font(.playfairDisplay(18, weight: .regular))
                    .foregroundColor(colorTheme.primaryWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
                
                VStack(spacing: 5) {
                    Text("Recorded today at \(formatTime(entry.createdAt))")
                        .font(.playfairDisplay(14, weight: .light))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    
                    Text("Color: \(entry.color.name)")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(entry.color.color.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            
            VStack(spacing: 15) {
                if dataManager.canEditToday() {
                    Button(action: {
                        showingEditView = IdentifiableID(entry.id)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16, weight: .medium))
                            Text("Edit Entry")
                                .font(.playfairDisplay(16, weight: .medium))
                        }
                        .foregroundColor(colorTheme.primaryPurple)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(colorTheme.primaryWhite)
                        .cornerRadius(22)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("\(dataManager.dayEntries.count)")
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(colorTheme.primaryWhite)
                        Text("Total Days")
                            .font(.playfairDisplay(12, weight: .light))
                            .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(dataManager.getStatistics().currentStreak)")
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(colorTheme.primaryWhite)
                        Text("Day Streak")
                            .font(.playfairDisplay(12, weight: .light))
                            .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(colorTheme.primaryWhite.opacity(0.1))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var canSave: Bool {
        selectedColor != nil && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadTodayEntry() {
        todayEntry = dataManager.getTodayEntry()
        
        if todayEntry == nil {
            selectedColor = nil
            description = ""
        }
    }
    
    private func saveDayEntry() {
        guard let color = selectedColor, !description.isEmpty else { return }
        
        let entry = DayEntry(date: Date(), color: color, description: description)
        dataManager.addDayEntry(entry)
        
        showingSaveConfirmation = true
        selectedColor = nil
        description = ""
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

