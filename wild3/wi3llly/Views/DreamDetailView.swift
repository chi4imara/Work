import SwiftUI

struct DreamDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let dreamId: UUID
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var editingDreamId: UUID?
    
    private var dream: DreamModel? {
        dataManager.dreams.first { $0.id == dreamId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if let dream = dream {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text(dream.title)
                                .font(.builderSans(.bold, size: 28))
                                .foregroundColor(Color.app.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.app.textTertiary)
                                        .font(.system(size: 14))
                                    
                                    Text(dream.createdAt, formatter: dateFormatter)
                                        .font(.builderSans(.medium, size: 14))
                                        .foregroundColor(Color.app.textSecondary)
                                }
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(Color.app.textTertiary)
                                        .font(.system(size: 14))
                                    
                                    Text(dream.createdAt, formatter: timeFormatter)
                                        .font(.builderSans(.medium, size: 14))
                                        .foregroundColor(Color.app.textSecondary)
                                }
                                
                                if dream.updatedAt != dream.createdAt {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color.app.textTertiary)
                                            .font(.system(size: 14))
                                        
                                        Text("Updated: \(dream.updatedAt, formatter: dateTimeFormatter)")
                                            .font(.builderSans(.light, size: 12))
                                            .foregroundColor(Color.app.textTertiary)
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.app.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.app.cardBorder, lineWidth: 1)
                                    )
                            )
                            
                            if !dream.tags.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Tags")
                                        .font(.builderSans(.semiBold, size: 18))
                                        .foregroundColor(Color.app.textPrimary)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.adaptive(minimum: 100))
                                    ], spacing: 8) {
                                        ForEach(dream.tags.sorted(), id: \.self) { tag in
                                            TagBadge(text: tag, color: Color.yellow)
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Dream Description")
                                    .font(.builderSans(.semiBold, size: 18))
                                    .foregroundColor(Color.app.textPrimary)
                                
                                Text(dream.content)
                                    .font(.builderSans(.regular, size: 16))
                                    .foregroundColor(Color.app.textSecondary)
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.app.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.app.cardBorder, lineWidth: 1)
                                            )
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    editingDreamId = dream.id
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Edit Dream")
                                    }
                                    .font(.builderSans(.semiBold, size: 16))
                                    .foregroundColor(Color.app.buttonText)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.app.buttonBackground)
                                    )
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete Dream")
                                    }
                                    .font(.builderSans(.semiBold, size: 16))
                                    .foregroundColor(Color.app.accentPink)
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.app.accentPink, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding(20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "moon.stars")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color.app.textTertiary)
                        
                        Text("Dream Not Found")
                            .font(.builderSans(.semiBold, size: 24))
                            .foregroundColor(Color.app.textPrimary)
                        
                        Text("This dream may have been deleted")
                            .font(.builderSans(.regular, size: 16))
                            .foregroundColor(Color.app.textSecondary)
                    }
                    .padding(32)
                }
            }
            .navigationTitle("Dream Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.app.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let dream = dream {
                        Menu {
                            Button(action: {
                                editingDreamId = dream.id
                                showingEditView = true
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                showingDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(Color.app.textPrimary)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let dreamId = editingDreamId ?? dream?.id {
                AddEditDreamView(dreamToEditId: dreamId)
            }
        }
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteDream()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
    }
    
    private func deleteDream() {
        dataManager.deleteDream(withId: dreamId)
        dismiss()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    let sampleDream = DreamModel(
        title: "Flying Over Ocean",
        content: "I was soaring high above a vast blue ocean, feeling completely weightless and free. The water below sparkled like diamonds in the sunlight, and I could see schools of colorful fish swimming beneath the surface. The sensation of flight was so vivid and real that I could feel the wind rushing through my hair.",
        tags: ["flying", "ocean", "freedom"]
    )
    DataManager.shared.addDream(sampleDream)
    
    return DreamDetailView(dreamId: sampleDream.id)
}
