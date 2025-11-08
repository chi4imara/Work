import SwiftUI

struct VictoryDetailView: View {
    let victoryId: UUID
    @ObservedObject var store: VictoryStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var victory: Victory? {
        store.victories.first { $0.id == victoryId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let victory = victory {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 20) {
                                Text(victory.title)
                                    .font(AppFonts.largeTitle)
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.leading)
                                
                                if let category = victory.category {
                                    HStack {
                                        Image(systemName: "folder.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.primaryYellow)
                                        
                                        Text("Category: \(category)")
                                            .font(AppFonts.headline)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.primaryYellow)
                                    
                                    Text(victory.date.formatted(date: .complete, time: .omitted))
                                        .font(AppFonts.headline)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                
                                if let note = victory.note, !note.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "note.text")
                                                .font(.system(size: 16))
                                                .foregroundColor(AppColors.primaryYellow)
                                            
                                            Text("Note")
                                                .font(AppFonts.headline)
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        
                                        Text(note)
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.cardBackground)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            
                            VStack(spacing: 12) {
                                Button {
                                    showingEditView = true
                                } label: {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Edit Victory")
                                            .font(AppFonts.buttonText)
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(AppColors.primaryYellow)
                                    .cornerRadius(12)
                                }
                                
                                Button {
                                    showingDeleteAlert = true
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Delete Victory")
                                            .font(AppFonts.buttonText)
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(AppColors.buttonDanger)
                                    .cornerRadius(12)
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(20)
                    }
                } else {
                    VStack {
                        Text("Victory not found")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryYellow)
                        .padding()
                    }
                }
            }
            .navigationTitle("Victory Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingEditView = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let victory = victory {
                AddEditVictoryView(store: store, editingVictory: victory)
            }
        }
        .alert("Delete Victory", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let victory = victory {
                    store.deleteVictory(victory)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this victory? This action cannot be undone.")
        }
    }
}

#Preview {
    let store = VictoryStore()
    return VictoryDetailView(
        victoryId: store.victories.first?.id ?? UUID(),
        store: store
    )
}
