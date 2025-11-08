import SwiftUI

struct DreamDetailView: View {
    @ObservedObject var dreamStore: DreamStore
    @Environment(\.dismiss) private var dismiss
    
    let dreamId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var dream: Dream? {
        dreamStore.dreams.first { $0.id == dreamId }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if let dream = dream {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dream.date, style: .date)
                                    .font(.dreamTitle)
                                    .foregroundColor(.dreamWhite)
                                
                                Text(dream.date, style: .time)
                                    .font(.dreamCaption)
                                    .foregroundColor(.dreamWhite.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            if dream.isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.dreamYellow)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Dream Description")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            Text(dream.description)
                                .font(.dreamBody)
                                .foregroundColor(.dreamWhite.opacity(0.9))
                                .lineSpacing(4)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.dreamWhite.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        if !dream.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Tags")
                                    .font(.dreamHeadline)
                                    .foregroundColor(.dreamWhite)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 8) {
                                    ForEach(dream.tags, id: \.self) { tag in
                                        TagBadgeView(tag: tag)
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                dreamStore.toggleFavorite(for: dream.id)
                            }) {
                                HStack {
                                    Image(systemName: dream.isFavorite ? "star.slash.fill" : "star.fill")
                                        .foregroundColor(.dreamYellow)
                                    
                                    Text(dream.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                        .font(.dreamSubheadline)
                                        .foregroundColor(dream.isFavorite ? .black : .dreamWhite)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(dream.isFavorite ? .yellow.opacity(0.7) : Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                    
                                        .stroke(Color.dreamYellow.opacity(0.5), lineWidth: 1)
                                )
                            }
                            
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.dreamWhite)
                                    
                                    Text("Edit Dream")
                                        .font(.dreamSubheadline)
                                        .foregroundColor(.dreamWhite)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.dreamBlue.opacity(0.6))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                    
                                    Text("Delete Dream")
                                        .font(.dreamSubheadline)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.dreamYellow.opacity(0.6))
                    
                    Text("Dream Not Found")
                        .font(.dreamHeadline)
                        .foregroundColor(.dreamWhite)
                    
                    Text("This dream may have been deleted or is no longer available.")
                        .font(.dreamBody)
                        .foregroundColor(.dreamWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .font(.dreamSubheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.dreamYellow)
                    .cornerRadius(8)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let dream = dream {
                AddEditDreamView(dreamStore: dreamStore, dreamToEdit: dream)
            }
        }
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let dream = dream {
                    dreamStore.deleteDream(dream)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationView {
        DreamDetailView(dreamStore: DreamStore(), dreamId: UUID())
    }
}
