import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(alignment: .leading, spacing: 20) {
                            titleSection
                            
                            dateSection
                            
                            contentSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                noteStore.deleteNote(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textLight)
            }
            
            Spacer()
            
            Text("Note Details")
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Menu {
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textLight)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Title")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textSecondary)
                    .textCase(.uppercase)
            }
            
            Text(note.title.isEmpty ? "Untitled Note" : note.title)
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
        )
    }
    
    private var dateSection: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentOrange)
            
            Text("Created")
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(DateFormatter.fullDate.string(from: note.dateCreated))
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Content")
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            if note.content.isEmpty {
                Text("No content added.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.textLight)
                    .italic()
            } else {
                Text(note.content)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .lineSpacing(6)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
        )
    }
}

extension DateFormatter {
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    let sampleNote = Note(
        title: "Winter Scent Ideas",
        content: "Add 'Fireside Glow' and 'Vanilla Musk' to the collection. These would be perfect for cozy winter evenings by the fireplace."
    )
    
    NoteDetailView(note: sampleNote, noteStore: NoteStore())
}
