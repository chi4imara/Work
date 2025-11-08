import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: RepairInstructionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedInstruction: RepairInstruction?
    
    private var searchResults: [RepairInstruction] {
        let activeInstructions = viewModel.instructions.filter { !$0.isArchived }
        
        if searchText.isEmpty {
            return activeInstructions.sorted { $0.title < $1.title }
        } else {
            return activeInstructions.filter { instruction in
                instruction.title.localizedCaseInsensitiveContains(searchText) ||
                instruction.shortDescription.localizedCaseInsensitiveContains(searchText) ||
                instruction.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                instruction.tools.joined().localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.title < $1.title }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                    
                    if searchResults.isEmpty && !searchText.isEmpty {
                        emptyStateView
                    } else {
                        resultsList
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .sheet(item: $selectedInstruction) { instruction in
            InstructionDetailView(instruction: instruction, viewModel: viewModel)
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Search instructions...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.cardBackground)
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(searchResults) { instruction in
                    SearchResultCard(instruction: instruction) {
                        selectedInstruction = instruction
                    } onFavoriteToggle: {
                        viewModel.toggleFavorite(for: instruction)
                    } onArchive: {
                        viewModel.archiveInstruction(instruction)
                    }
                    .id("\(instruction.id)-\(instruction.isFavorite)")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("Nothing Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text("Try different keywords or check your spelling")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Clear Search") {
                searchText = ""
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

struct SearchResultCard: View {
    let instruction: RepairInstruction
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    let onArchive: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var showingArchiveConfirmation = false
    @State private var isFavorite: Bool
    
    init(instruction: RepairInstruction, onTap: @escaping () -> Void, onFavoriteToggle: @escaping () -> Void, onArchive: @escaping () -> Void) {
        self.instruction = instruction
        self.onTap = onTap
        self.onFavoriteToggle = onFavoriteToggle
        self.onArchive = onArchive
        self._isFavorite = State(initialValue: instruction.isFavorite)
    }
    
    var body: some View {
        ZStack {
            HStack {
                if dragOffset.width > 0 {
                    Button(action: {
                        isFavorite.toggle()
                        onFavoriteToggle()
                    }) {
                        VStack {
                            Image(systemName: isFavorite ? "star.slash.fill" : "star.fill")
                                .font(.title2)
                            Text(isFavorite ? "Remove" : "Favorite")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentOrange)
                    .cornerRadius(12)
                }
                
                Spacer()
                
                if dragOffset.width < 0 {
                    Button(action: { showingArchiveConfirmation = true }) {
                        VStack {
                            Image(systemName: "archivebox.fill")
                                .font(.title2)
                            Text("Archive")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentRed)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            
            Button(action: onTap) {
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(categoryColor.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: instruction.category.icon)
                            .font(.title2)
                            .foregroundColor(categoryColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(instruction.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.accentOrange)
                            }
                        }
                        
                        Text(instruction.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(instruction.shortDescription)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.cardBackground)
                .cornerRadius(12)
                .shadow(color: Color.cardShadow, radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                                            .onEnded { value in
                            withAnimation(.spring()) {
                                if abs(value.translation.width) > 100 {
                                    if value.translation.width > 0 {
                                        isFavorite.toggle()
                                        onFavoriteToggle()
                                    } else {
                                        showingArchiveConfirmation = true
                                    }
                                }
                                dragOffset = .zero
                            }
                        }
            )
        }
        .onAppear {
            isFavorite = instruction.isFavorite
        }
        .alert("Archive Instruction", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                onArchive()
            }
        } message: {
            Text("This instruction will be moved to the archive and removed from the handbook.")
        }
    }
    
    private var categoryColor: Color {
        switch instruction.category.icon {
        case "drop.fill": return Color.primaryBlue
        case "bolt.fill": return Color.accentOrange
        case "chair.fill": return Color.accentGreen
        case "paintbrush.fill": return Color.accentRed
        case "leaf.fill": return Color.accentGreen
        default: return Color.textSecondary
        }
    }
}

#Preview {
    SearchView(viewModel: RepairInstructionViewModel())
}

