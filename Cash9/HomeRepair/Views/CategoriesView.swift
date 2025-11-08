import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: RepairInstructionViewModel
    @State private var selectedCategory: RepairCategory?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    categoriesGrid
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryDetailView(category: category, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 15) {
                ForEach(RepairCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        instructionCount: viewModel.instructionsByCategory(category).count
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct CategoryCard: View {
    let category: RepairCategory
    let instructionCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 35))
                        .foregroundColor(categoryColor)
                }
                
                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("\(instructionCount) instruction\(instructionCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.cardShadow, radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryColor: Color {
        switch category.icon {
        case "drop.fill": return Color.primaryBlue
        case "bolt.fill": return Color.accentOrange
        case "chair.fill": return Color.accentGreen
        case "paintbrush.fill": return Color.accentRed
        case "leaf.fill": return Color.accentGreen
        default: return Color.textSecondary
        }
    }
}

struct CategoryDetailView: View {
    let category: RepairCategory
    @ObservedObject var viewModel: RepairInstructionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedInstruction: RepairInstruction?
    
    private var categoryInstructions: [RepairInstruction] {
        let instructions = viewModel.instructionsByCategory(category)
        
        if searchText.isEmpty {
            return instructions.sorted { $0.title < $1.title }
        } else {
            return instructions.filter { instruction in
                instruction.title.localizedCaseInsensitiveContains(searchText) ||
                instruction.shortDescription.localizedCaseInsensitiveContains(searchText)
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
                    
                    if categoryInstructions.isEmpty {
                        emptyStateView
                    } else {
                        instructionsList
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text(category.rawValue)
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
                
                TextField("Search in \(category.rawValue.lowercased())...", text: $searchText)
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
    
    private var instructionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryInstructions) { instruction in
                    InstructionCard(instruction: instruction) {
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
            Image(systemName: category.icon)
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text(searchText.isEmpty ? "No Instructions Yet" : "Nothing Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(searchText.isEmpty ? 
                 "This category doesn't have any instructions yet." :
                 "Try different keywords or check your spelling")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            if searchText.isEmpty {
                Button("Go to Handbook") {
                    dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.primaryBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
            } else {
                Button("Clear Search") {
                    searchText = ""
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
}

extension RepairCategory: Identifiable {
    var id: String { rawValue }
}

#Preview {
    CategoriesView(viewModel: RepairInstructionViewModel())
}

