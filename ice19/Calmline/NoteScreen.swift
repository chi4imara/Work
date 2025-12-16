import SwiftUI

struct NoteScreen: View {
    @Binding var entry: DayEntry
    @EnvironmentObject var dataManager: DataManager
    
    @State private var noteText: String = ""
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                headerSection
                
                if entry.note.isEmpty && !isEditing {
                    emptyStateSection
                } else if isEditing {
                    editingSection
                } else {
                    viewingSection
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .onAppear {
            noteText = entry.note
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(ColorManager.shared.primaryBlue)
            
            Spacer()
            
            VStack {
                Text("Day Note")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Text(DateFormatter.dayFormatter.string(from: entry.date))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.shared.darkGray)
            }
            
            Spacer()
            
                Button("Edit") {
                    isEditing = true
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .disabled(true)
                .opacity(0)
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 30) {
            Image(systemName: "square.and.pencil.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.shared.primaryPurple.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("You can write a few lines about your day — this will help you notice progress.")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Share what helped you maintain inner balance.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            
            Button {
                isEditing = true
            } label: {
                Text("Add Note")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorManager.shared.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.vertical, 40)
    }
    
    private var editingSection: some View {
        VStack(spacing: 20) {
            Text("Share what helped you maintain inner balance.")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .multilineTextAlignment(.center)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.shared.cardGradient)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                TextEditor(text: $noteText)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .padding(16)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                
                if noteText.isEmpty {
                    Text("Today I felt calm because...")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorManager.shared.darkGray.opacity(0.5))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 200)
            
            HStack(spacing: 16) {
                Button {
                    noteText = entry.note
                    if entry.note.isEmpty {
                        isEditing = false
                    } else {
                        isEditing = false
                    }
                } label: {
                    Text("Cancel")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(ColorManager.shared.lightGray)
                        .cornerRadius(20)
                }
                
                Button {
                    saveNote()
                } label: {
                    Text("Save Note")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(ColorManager.shared.primaryYellow)
                        .cornerRadius(20)
                        .shadow(color: ColorManager.shared.primaryYellow.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
        }
    }
    
    private var viewingSection: some View {
        VStack(spacing: 20) {
            Text("Your note for this day:")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(entry.note)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            Button {
                isEditing = true
            } label: {
                Text("Edit Note")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(ColorManager.shared.primaryPurple)
                    .cornerRadius(20)
                    .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    private func saveNote() {
        entry.note = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        dataManager.updateTodayEntry(entry)
        isEditing = false
        
        if entry.note.isEmpty {
        } else {
        }
    }
}

#Preview {
    @State var sampleEntry = DayEntry(date: Date())
    
    return NoteScreen(entry: $sampleEntry)
        .environmentObject(DataManager.shared)
}
