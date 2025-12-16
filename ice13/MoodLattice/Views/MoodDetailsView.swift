import SwiftUI

struct MoodDetailsView: View {
    @ObservedObject var dataManager: MoodDataManager
    let entryDate: Date
    
    @Environment(\.presentationMode) var presentationMode
    @State private var sheetItem: SheetItem?
    @State private var showingDeleteConfirmation = false
    
    private var entry: MoodEntry? {
        dataManager.entryForDate(entryDate)
    }
    
    enum SheetItem: Identifiable {
        case editEntry(date: Date, entry: MoodEntry?)
        
        var id: String {
            switch self {
            case .editEntry(let date, _):
                return "editEntry_\(date.timeIntervalSince1970)"
            }
        }
    }
    
    var body: some View {
        Group {
            if let entry = entry {
                NavigationView {
                    ZStack {
                        GradientBackground()
                        
                        ScrollView {
                            VStack(spacing: 30) {
                                dateHeaderView(entry: entry)
                                
                                moodDisplayView(entry: entry)
                                
                                if !entry.note.isEmpty {
                                    noteDisplayView(entry: entry)
                                }
                                
                                actionButtonsView(entry: entry)
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle("Mood Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .sheet(item: $sheetItem) { item in
                    switch item {
                    case .editEntry(let date, _):
                        MoodEntryView(
                            dataManager: dataManager,
                            selectedDate: date,
                            entryToEdit: dataManager.entryForDate(date)
                        )
                    }
                }
                .alert(isPresented: $showingDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Entry"),
                        message: Text("Delete entry for \(entry.dateString)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            dataManager.deleteEntry(entry)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            } else {
                NavigationView {
                    ZStack {
                        GradientBackground()
                        
                        VStack(spacing: 20) {
                            Text("Entry not found")
                                .font(FontManager.ubuntu(size: 20, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Button("Back to Calendar") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(FontManager.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(AppColors.accent)
                            .cornerRadius(20)
                        }
                    }
                    .navigationTitle("Mood Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
        }
    }
    
    private func dateHeaderView(entry: MoodEntry) -> some View {
        VStack(spacing: 10) {
            Text(entry.dateString)
                .font(FontManager.ubuntu(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("(\(entry.dayOfWeek))")
                .font(FontManager.ubuntu(size: 18, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private func moodDisplayView(entry: MoodEntry) -> some View {
        VStack(spacing: 20) {
            Text(entry.mood.rawValue)
                .font(.system(size: 80))
                .padding(.top, 10)
            
            Text(entry.mood.name)
                .font(FontManager.ubuntu(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            HStack {
                Circle()
                    .fill(moodColor(for: entry.mood))
                    .frame(width: 12, height: 12)
                
                Text(entry.mood.name.uppercased())
                    .font(FontManager.ubuntu(size: 14, weight: .bold))
                    .foregroundColor(moodColor(for: entry.mood))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(moodColor(for: entry.mood).opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private func noteDisplayView(entry: MoodEntry) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.accent)
                
                Text("Note")
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(entry.note)
                .font(FontManager.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private func actionButtonsView(entry: MoodEntry) -> some View {
        VStack(spacing: 15) {
            Button(action: {
                sheetItem = .editEntry(date: entry.date, entry: nil)
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit")
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.accent)
                .cornerRadius(25)
            }
            
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete")
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(25)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private func moodColor(for mood: MoodType) -> Color {
        switch mood {
        case .happy:
            return AppColors.happyMood
        case .calm:
            return AppColors.calmMood
        case .neutral:
            return AppColors.neutralMood
        case .sad:
            return AppColors.sadMood
        case .angry:
            return AppColors.angryMood
        }
    }
}

#Preview {
    let dataManager = MoodDataManager()
    let entry = MoodEntry(
        date: Date(),
        mood: .happy,
        note: "Had a great day with friends. We went to the park and had a picnic. The weather was perfect and everyone was in a good mood."
    )
    dataManager.addEntry(entry)
    return MoodDetailsView(
        dataManager: dataManager,
        entryDate: entry.date
    )
}
