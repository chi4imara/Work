import SwiftUI

enum CategoriesEditMode: Identifiable {
    case edit(MakeupIdea)
    
    var id: String {
        switch self {
        case .edit(let idea): return idea.id.uuidString
        }
    }
}

struct CategoriesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MakeupIdeaViewModel
    @State private var selectedCategory: MakeupTag?
    @State private var ideaToView: MakeupIdea?
    @State private var editMode: CategoriesEditMode?
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Makeup Categories")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if selectedCategory == nil {
                    CategoriesListView(
                        categorizedIdeas: viewModel.categorizedIdeas,
                        onCategoryTapped: { category in
                            selectedCategory = category
                        }
                    )
                } else {
                    CategoryDetailView(
                        category: selectedCategory!,
                        ideas: viewModel.categorizedIdeas[selectedCategory!] ?? [],
                        onBack: {
                            selectedCategory = nil
                        },
                        onIdeaTapped: { idea in
                            ideaToView = idea
                        }
                    )
                }
            }
        }
        .sheet(item: $ideaToView) { idea in
            IdeaDetailView(idea: idea) { updatedIdea in
                viewModel.updateIdea(updatedIdea)
            } onDelete: { ideaToDelete in
                viewModel.deleteIdea(ideaToDelete)
            } onEdit: { ideaToEdit in
                ideaToView = nil
                editMode = .edit(ideaToEdit)
            }
            .environmentObject(viewModel)
        }
        .sheet(item: $editMode) { mode in
            switch mode {
            case .edit(let idea):
                AddEditIdeaView(ideaToEdit: idea) { updatedIdea in
                    viewModel.updateIdea(updatedIdea)
                }
                .environmentObject(viewModel)
            }
        }
    }
}

struct CategoriesListView: View {
    let categorizedIdeas: [MakeupTag: [MakeupIdea]]
    let onCategoryTapped: (MakeupTag) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(MakeupTag.allCases, id: \.self) { tag in
                    CategoryCardView(
                        tag: tag,
                        ideasCount: categorizedIdeas[tag]?.count ?? 0,
                        onTap: {
                            onCategoryTapped(tag)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryCardView: View {
    let tag: MakeupTag
    let ideasCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: tag.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tag.displayName)
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(ideasCount == 0 ? "No ideas yet" : "\(ideasCount) idea\(ideasCount == 1 ? "" : "s")")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(CardBackground())
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(ideasCount == 0)
        .opacity(ideasCount == 0 ? 0.6 : 1.0)
    }
}

struct CategoryDetailView: View {
    let category: MakeupTag
    let ideas: [MakeupIdea]
    let onBack: () -> Void
    let onIdeaTapped: (MakeupIdea) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Categories")
                            .font(AppFonts.body)
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            HStack(spacing: 16) {
                Image(systemName: category.icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(ideas.count) idea\(ideas.count == 1 ? "" : "s")")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            if ideas.isEmpty {
                CategoryEmptyStateView(category: category)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(ideas.sorted { $0.dateCreated > $1.dateCreated }) { idea in
                            CategoryIdeaCardView(
                                idea: idea,
                                onTap: {
                                    onIdeaTapped(idea)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct CategoryEmptyStateView: View {
    let category: MakeupTag
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: category.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            Text("No ideas in this category yet")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add at least one idea to start your \(category.displayName.lowercased()) collection.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CategoryIdeaCardView: View {
    let idea: MakeupIdea
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(idea.title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                
                Text(idea.description)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    Text(idea.dateCreated.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    if !idea.comment.isEmpty {
                        Image(systemName: "note.text")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CardBackground())
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
