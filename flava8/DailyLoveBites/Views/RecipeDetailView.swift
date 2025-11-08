import SwiftUI

struct RecipeDetailView: View {
    let recipeId: UUID
    @ObservedObject var viewModel: RecipeViewModel
    let onTagTap: ((String) -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditRecipe = false
    @State private var showingStepByStep = false
    @State private var showingDeleteAlert = false
    @State private var showingActionSheet = false
    
    private var recipe: Recipe? {
        viewModel.recipes.first { $0.id == recipeId }
    }
    
    init(recipe: Recipe, viewModel: RecipeViewModel, onTagTap: ((String) -> Void)? = nil) {
        self.recipeId = recipe.id
        self.viewModel = viewModel
        self.onTagTap = onTagTap
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            headerSection(recipe)
                            
                            metadataSection(recipe)
                            
                            if !recipe.tags.isEmpty {
                                tagsSection(recipe)
                            }
                            
                            ingredientsSection(recipe)
                            
                            stepsSection(recipe)
                            
                            if let notes = recipe.notes, !notes.isEmpty {
                                notesSection(notes)
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Recipe Not Found")
                            .font(AppFonts.titleMedium)
                            .foregroundColor(.white)
                        
                        Text("This recipe may have been deleted")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(AppFonts.buttonMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.primaryPurple)
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditRecipe) {
                if let recipe = recipe {
                    AddEditRecipeView(viewModel: viewModel, editingRecipe: recipe)
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                if let recipe = recipe {
                    ActionSheet(
                        title: Text(recipe.name),
                        buttons: [
                            .default(Text("Duplicate Recipe")) {
                                _ = viewModel.duplicateRecipe(recipe)
                            },
                            .destructive(Text("Delete Recipe")) {
                                showingDeleteAlert = true
                            },
                            .cancel()
                        ]
                    )
                } else {
                    ActionSheet(
                        title: Text("Error"),
                        buttons: [
                            .cancel()
                        ]
                    )
                }
            }
            .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let recipe = recipe {
                        viewModel.deleteRecipe(recipe)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } message: {
                if let recipe = recipe {
                    Text("Are you sure you want to delete '\(recipe.name)'? This action cannot be undone.")
                } else {
                    Text("Recipe not found.")
                }
            }
        }
    }
    
    private func headerSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { viewModel.toggleRecipeFavorite(recipe) }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(recipe.isFavorite ? .errorRed : .white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingEditRecipe = true }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingActionSheet = true }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            
            Text(recipe.name)
                .font(AppFonts.titleLarge)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
    }
    
    private func metadataSection(_ recipe: Recipe) -> some View {
        HStack(spacing: 16) {
            if let cookingTime = recipe.cookingTime {
                MetadataItem(
                    icon: "clock",
                    text: "\(cookingTime) min",
                    color: .accentOrange
                )
            }
            
            MetadataItem(
                icon: "person.2",
                text: recipe.formattedServings,
                color: .accentPink
            )
            
            MetadataItem(
                icon: "chart.bar",
                text: recipe.difficulty.localizedString,
                color: recipe.difficulty == .easy ? .successGreen :
                       recipe.difficulty == .medium ? .warningYellow : .errorRed
            )
            
            Spacer()
        }
    }
    
    private func tagsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                ForEach(recipe.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(AppFonts.bodySmall)
                            .foregroundColor(.primaryPurple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                    }
            }
        }
    }
    
    private func ingredientsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(recipe.ingredients.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.primaryPurple)
                            .frame(width: 8)
                        
                        Text(recipe.ingredients[index].displayText)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.darkText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private func stepsSection(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Cooking Steps")
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(recipe.steps.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(AppFonts.bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryPurple)
                            .frame(width: 24, height: 24)
                            .background(Color.primaryPurple.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text(recipe.steps[index].description)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.darkText)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func notesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            Text(notes)
                .font(AppFonts.bodyMedium)
                .foregroundColor(.darkText)
                .padding(16)
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
        }
    }
}

struct MetadataItem: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            
            Text(text)
                .font(AppFonts.bodySmall)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}
