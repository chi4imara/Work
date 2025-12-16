import SwiftUI

struct EditDayView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    
    @State private var selectedColor: MoodColor?
    @State private var description: String = ""
    @State private var showingSaveConfirmation = false
    @State private var showingDeleteConfirmation = false
    
    let entry: DayEntry?
    private let isEditing: Bool
    
    init(entry: DayEntry? = nil) {
        self.entry = entry
        self.isEditing = entry != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        colorSelectionView
                        descriptionView
                        dateTimeView
                        actionButtonsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                setupInitialValues()
            }
            .alert("Day Saved", isPresented: $showingSaveConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your mood color has been saved!")
            }
            .alert("Delete Day", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteEntry()
                }
            } message: {
                Text("Are you sure you want to delete this day?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                    .frame(width: 44, height: 44)
                    .background(colorTheme.primaryPurple.opacity(0.3))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text(isEditing ? "Edit Day" : "New Day")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(colorTheme.primaryWhite)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    private var colorSelectionView: some View {
        VStack(spacing: 20) {
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
            Text("Why did you choose this color?")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
            
            TextEditor(text: $description)
                .font(.playfairDisplay(14))
                .padding(12)
                .background(colorTheme.primaryWhite.opacity(0.9))
                .cornerRadius(12)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
    }
    
    private var dateTimeView: some View {
        VStack(spacing: 5) {
            Text(formatDate(Date()))
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
            
            Text(formatTime(Date()))
                .font(.playfairDisplay(12, weight: .light))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 15) {
            Button(action: saveEntry) {
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
            
            if isEditing {
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Text("Delete")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(colorTheme.errorRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(colorTheme.primaryWhite.opacity(0.2))
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(colorTheme.errorRed.opacity(0.5), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var canSave: Bool {
        selectedColor != nil && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func setupInitialValues() {
        if let entry = entry {
            selectedColor = entry.color
            description = entry.description
        }
    }
    
    private func saveEntry() {
        guard let color = selectedColor, !description.isEmpty else { return }
        
        if let existingEntry = entry {
            let updatedEntry = existingEntry.updated(color: color, description: description)
            dataManager.updateDayEntry(updatedEntry)
        } else {
            let newEntry = DayEntry(date: Date(), color: color, description: description)
            dataManager.addDayEntry(newEntry)
        }
        
        showingSaveConfirmation = true
    }
    
    private func deleteEntry() {
        guard let entry = entry else { return }
        dataManager.deleteDayEntry(entry)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EditDayView()
}
