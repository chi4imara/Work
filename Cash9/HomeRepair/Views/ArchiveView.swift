import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: RepairInstructionViewModel
    @State private var searchText = ""
    @State private var selectedCategories: Set<RepairCategory> = Set(RepairCategory.allCases)
    @State private var selectedInstruction: RepairInstruction?
    @State private var showingClearArchiveConfirmation = false
    @State private var showingFilters = false
    
    private var filteredArchivedInstructions: [RepairInstruction] {
        var filtered = viewModel.archivedInstructions
        
        if selectedCategories.count < RepairCategory.allCases.count {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { instruction in
                instruction.title.localizedCaseInsensitiveContains(searchText) ||
                instruction.shortDescription.localizedCaseInsensitiveContains(searchText) ||
                instruction.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchAndFilterBar
                    
                    if selectedCategories.count < RepairCategory.allCases.count {
                        filterStatusView
                    }
                    
                    if filteredArchivedInstructions.isEmpty {
                        emptyStateView
                    } else {
                        archiveList
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            ArchiveFilterView(selectedCategories: $selectedCategories)
        }
        .sheet(item: $selectedInstruction) { instruction in
            ArchivedInstructionDetailView(instruction: instruction, viewModel: viewModel)
        }
        .alert("Restore All Instructions", isPresented: $showingClearArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Restore All") {
                restoreAllInstructions()
            }
        } message: {
            Text("This will restore all archived instructions back to the handbook.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Archive")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if !viewModel.archivedInstructions.isEmpty {
                Button("Restore All") {
                    showingClearArchiveConfirmation = true
                }
                .font(.caption)
                .foregroundColor(.accentGreen)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFilterBar: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Search archived instructions...", text: $searchText)
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
            
            Button(action: { showingFilters = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var filterStatusView: some View {
        HStack {
            Text("\(selectedCategories.count) of \(RepairCategory.allCases.count) categories selected")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Button("Reset") {
                selectedCategories = Set(RepairCategory.allCases)
            }
            .font(.caption)
            .foregroundColor(.primaryBlue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.lightBlue.opacity(0.3))
    }
    
    private var archiveList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredArchivedInstructions) { instruction in
                    ArchivedInstructionCard(instruction: instruction) {
                        selectedInstruction = instruction
                    } onRestore: {
                        viewModel.restoreInstruction(instruction)
                    } onDelete: {
                        viewModel.deleteInstruction(instruction)
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
            Image(systemName: "archivebox")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text(viewModel.archivedInstructions.isEmpty ? "Archive is Empty" : "No Results")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(viewModel.archivedInstructions.isEmpty ? 
                 "Archived instructions will appear here" :
                 "Try adjusting your search or filters")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            if !viewModel.archivedInstructions.isEmpty {
                Button("Clear Filters") {
                    searchText = ""
                    selectedCategories = Set(RepairCategory.allCases)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.primaryBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    private func restoreAllInstructions() {
        for instruction in viewModel.archivedInstructions {
            viewModel.restoreInstruction(instruction)
        }
    }
}

struct ArchivedInstructionCard: View {
    let instruction: RepairInstruction
    let onTap: () -> Void
    let onRestore: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var isFavorite: Bool
    
    init(instruction: RepairInstruction, onTap: @escaping () -> Void, onRestore: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.instruction = instruction
        self.onTap = onTap
        self.onRestore = onRestore
        self.onDelete = onDelete
        self._isFavorite = State(initialValue: instruction.isFavorite)
    }
    
    var body: some View {
        ZStack {
            HStack {
                if dragOffset.width > 0 {
                    Button(action: onRestore) {
                        VStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title2)
                            Text("Restore")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentGreen)
                    .cornerRadius(12)
                }
                
                Spacer()
                
                if dragOffset.width < 0 {
                    Button(action: onRestore) {
                        VStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title2)
                            Text("Restore")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentGreen)
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
                        Text(instruction.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        Text(instruction.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(instruction.shortDescription)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                        
                        if let dateArchived = instruction.dateArchived {
                            Text("Archived \(dateArchived, style: .date)")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.cardBackground.opacity(0.8))
                .cornerRadius(12)
                .shadow(color: Color.cardShadow, radius: 3, x: 0, y: 1)
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
                                        onRestore()
                                    } else {
                                        onRestore()
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

struct ArchiveFilterView: View {
    @Binding var selectedCategories: Set<RepairCategory>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filter Archive")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(RepairCategory.allCases, id: \.self) { category in
                                CategoryFilterRow(
                                    category: category,
                                    isSelected: selectedCategories.contains(category),
                                    instructionCount: 0
                                ) {
                                    if selectedCategories.contains(category) {
                                        selectedCategories.remove(category)
                                    } else {
                                        selectedCategories.insert(category)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Apply")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.primaryBlue)
                                .cornerRadius(12)
                        }
                        
                        Button {
                            selectedCategories = Set(RepairCategory.allCases)
                        } label: {
                            Text("Select All")
                                .font(.headline)
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .padding(.top, -35)
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
            }
        }
    }
}

#Preview {
    ArchiveView(viewModel: RepairInstructionViewModel())
}

