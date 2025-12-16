import SwiftUI

struct MemoryDetailView: View {
    let memoryID: UUID
    @ObservedObject var memoryStore: MemoryStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var memory: Memory? {
        memoryStore.memoryForID(memoryID)
    }
    
    var body: some View {
        Group {
            if let currentMemory = memory {
                MemoryDetailContentView(
                    memory: currentMemory,
                    memoryStore: memoryStore,
                    showingEditView: $showingEditView,
                    showingDeleteAlert: $showingDeleteAlert
                )
            } else {
                Color.clear
                    .onAppear {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}

struct MemoryDetailContentView: View {
    let memory: Memory
    @ObservedObject var memoryStore: MemoryStore
    @Binding var showingEditView: Bool
    @Binding var showingDeleteAlert: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        memoryContentView(memory: memory)
                        
                        actionButtonsView(memory: memory)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Memory from \(DateFormatter.shortDate.string(from: memory.date))")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddMemoryView(memoryStore: memoryStore, existingMemory: memory)
        }
        .alert("Delete Memory", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                memoryStore.deleteMemory(memory)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this memory? This action cannot be undone.")
        }
    }
    
    private func memoryContentView(memory: Memory) -> some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(DateFormatter.fullDate.string(from: memory.date))
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(DateFormatter.timeOnly.string(from: memory.date))
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(memory.mood)
                    .font(.system(size: 48))
            }
            
            Divider()
                .background(AppColors.textSecondary.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(memory.title)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(memory.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(4)
            }
        }
        .padding(24)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private func actionButtonsView(memory: Memory) -> some View {
        VStack(spacing: 16) {
            Button(action: { memoryStore.toggleFavorite(memory) }) {
                HStack {
                    Image(systemName: memory.isFavorite ? "star.fill" : "star")
                    Text(memory.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(memory.isFavorite ? .white : AppColors.primaryYellow)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(memory.isFavorite ? AnyShapeStyle(AppColors.primaryYellow) : AnyShapeStyle(AppColors.cardGradient))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.primaryYellow, lineWidth: memory.isFavorite ? 0 : 2)
                )
            }
            
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(20)
            }
        }
    }
}

extension DateFormatter {
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    let store = MemoryStore()
    if let firstMemory = Memory.sampleMemories.first {
        store.addMemory(firstMemory)
        return MemoryDetailView(
            memoryID: firstMemory.id,
            memoryStore: store
        )
    }
    return MemoryDetailView(
        memoryID: UUID(),
        memoryStore: store
    )
}
