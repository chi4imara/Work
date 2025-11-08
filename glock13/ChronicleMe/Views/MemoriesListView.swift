import SwiftUI

struct MemoriesListView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingAddMemory = false
    @State private var showingFilterMenu = false
    @State private var showingClearConfirmation = false
    @State private var memoryToEdit: Memory?
    @State private var memoryToDelete: Memory?
    @State private var showingDeleteConfirmation = false
    @State private var selectedMemory: Memory?
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if memoryStore.filteredMemories.isEmpty {
                    emptyStateView
                } else {
                    memoriesListContent
                }
            }
        }
        .sheet(isPresented: $showingAddMemory) {
            AddEditMemoryView(memoryStore: memoryStore, memoryToEdit: nil)
        }
        .sheet(item: $memoryToEdit) { memory in
            AddEditMemoryView(memoryStore: memoryStore, memoryToEdit: memory)
        }
        .sheet(item: $selectedMemory) { memory in
            NavigationView {
                MemoryDetailView(memoryStore: memoryStore, memory: memory)
            }
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
        .alert("Clear Collection", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                memoryStore.clearAllMemories()
            }
        } message: {
            Text("Are you sure you want to delete all memories? This action cannot be undone.")
        }
        .alert("Delete Memory", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let memory = memoryToDelete {
                    memoryStore.deleteMemory(memory)
                    memoryToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this memory?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Memories")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingAddMemory = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Collection is empty")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first memory")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button(action: { showingAddMemory = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Memory")
                }
                .font(AppFonts.buttonMedium)
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.buttonBackground)
                .cornerRadius(10)
            }
            
            Spacer()
        }
    }
    
    private var memoriesListContent: some View {
        VStack(spacing: 0) {
            if memoryStore.currentFilter != .all {
                HStack {
                    Text("Filter: \(memoryStore.currentFilter.localizedTitle)")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Spacer()
                    
                    Button("Reset") {
                        memoryStore.setFilter(.all)
                    }
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.primaryYellow)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(memoryStore.filteredMemories) { memory in
                        MemoryCardView(memory: memory) {
                            selectedMemory = memory
                        }
                        .contextMenu {
                            Button(action: { memoryToEdit = memory }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                memoryToDelete = memory
                                showingDeleteConfirmation = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(action: {
                                memoryToDelete = memory
                                showingDeleteConfirmation = true
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(AppColors.deleteRed)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: { memoryToEdit = memory }) {
                                Image(systemName: "pencil")
                            }
                            .tint(AppColors.editGreen)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter Options"),
            buttons: [
                .default(Text("Today")) { memoryStore.setFilter(.today) },
                .default(Text("This Week")) { memoryStore.setFilter(.week) },
                .default(Text("This Month")) { memoryStore.setFilter(.month) },
                .default(Text("All Time")) { memoryStore.setFilter(.all) },
                .destructive(Text("Clear Collection")) { showingClearConfirmation = true },
                .cancel()
            ]
        )
    }
}

struct MemoryCardView: View {
    let memory: Memory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(memory.shortText)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if memory.isImportant {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.importantStar)
                        }
                    }
                    
                    Text(memory.formattedDate)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MemoriesListView(memoryStore: MemoryStore())
}
