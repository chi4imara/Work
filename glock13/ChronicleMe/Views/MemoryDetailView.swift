import SwiftUI

struct MemoryDetailView: View {
    @ObservedObject var memoryStore: MemoryStore
    let memory: Memory
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    private var currentMemory: Memory {
        memoryStore.memories.first { $0.id == memory.id } ?? memory
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if currentMemory.isImportant {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(AppColors.importantStar)
                                Text("Important")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.importantStar)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.importantStar.opacity(0.2))
                            )
                            
                            Spacer()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Event Date")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(currentMemory.formattedDate)
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Divider()
                        .overlay {
                            Color.white
                        }
                        .padding(.horizontal, -20)
                        .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Memory")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(currentMemory.text)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryText)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                        .overlay {
                            Color.white
                        }
                        .padding(.horizontal, -20)
                        .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Created")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(formatCreatedDate(currentMemory.createdAt))
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Memory Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditView = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showingEditView) {
            AddEditMemoryView(memoryStore: memoryStore, memoryToEdit: currentMemory)
        }
        .alert("Delete Memory", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                memoryStore.deleteMemory(currentMemory)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this memory? This action cannot be undone.")
        }
    }
    
    private func formatCreatedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        MemoryDetailView(
            memoryStore: MemoryStore(),
            memory: Memory(
                text: "This is a sample memory text that demonstrates how the detail view looks with longer content. It should wrap nicely and be easy to read.",
                date: Date(),
                isImportant: true
            )
        )
    }
}
