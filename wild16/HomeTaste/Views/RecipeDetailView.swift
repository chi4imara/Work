import SwiftUI

enum RecipeDetailSheetItem: Identifiable {
    case editRecipe(UUID)
    
    var id: String {
        switch self {
        case .editRecipe(let recipeId):
            return "editRecipe-\(recipeId.uuidString)"
        }
    }
}

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var recipeStore: RecipeStore
    @EnvironmentObject var noteStore: NoteStore
    
    let recipeId: UUID
    
    @State private var sheetItem: RecipeDetailSheetItem?
    @State private var showingDeleteAlert = false
    @State private var noteText = ""
    @State private var showingNoteConfirmation = false
    
    private var recipe: Recipe? {
        recipeStore.getRecipe(by: recipeId)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let recipe = recipe {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.primaryYellow.opacity(0.8))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "fork.knife")
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.title)
                                            .font(FontManager.title2)
                                            .foregroundColor(AppColors.textPrimary)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("Added \(dateFormatter.string(from: recipe.dateCreated))")
                                            .font(FontManager.caption1)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(20)
                                .background(AppColors.cardGradient)
                                .cornerRadius(16)
                            }
                            
                            if !recipe.ingredients.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Ingredients")
                                        .font(FontManager.headline)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(recipe.ingredients)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                }
                            }
                            
                            if !recipe.instructions.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Cooking Instructions")
                                        .font(FontManager.headline)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(recipe.instructions)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                }
                            }
                            
                            VStack(spacing: 12) {
                            Button(action: {
                                sheetItem = .editRecipe(recipeId)
                            }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Edit Recipe")
                                            .font(FontManager.callout)
                                    }
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(22)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Delete Recipe")
                                            .font(FontManager.callout)
                                    }
                                    .foregroundColor(AppColors.warning)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(22)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Add Note")
                                    .font(FontManager.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                ZStack(alignment: .topLeading) {
                                    if noteText.isEmpty {
                                        Text("What can be improved or tried differently?")
                                            .font(FontManager.body)
                                            .foregroundColor(AppColors.textSecondary.opacity(0.7))
                                            .padding(16)
                                    }
                                    
                                    TextEditor(text: $noteText)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(12)
                                        .background(Color.clear)
                                        .scrollContentBackground(.hidden)
                                }
                                .frame(minHeight: 100)
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                                
                                Button(action: saveNote) {
                                    HStack {
                                        Image(systemName: "note.text.badge.plus")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Save Note")
                                            .font(FontManager.callout)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                               AppColors.textSecondary.opacity(0.5) : AppColors.primaryBlue)
                                    .cornerRadius(22)
                                }
                                .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("This recipe is unavailable")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("It may have been deleted or not saved completely.")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back to List")
                                .font(FontManager.callout)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .navigationTitle("Recipe Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Back")
                        }
                        .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .editRecipe(let recipeId):
                Group {
                    if let recipe = recipeStore.getRecipe(by: recipeId) {
                        AddEditRecipeView(recipe: recipe, category: recipe.category) { updatedRecipe in
                            recipeStore.updateRecipe(updatedRecipe)
                        }
                        .environmentObject(recipeStore)
                    } else {
                        Text("Recipe not found")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let currentRecipe = recipe {
                    recipeStore.deleteRecipe(currentRecipe)
                    noteStore.removeRecipeLink(recipeId: currentRecipe.id)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
        .alert("Note Added", isPresented: $showingNoteConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your note has been saved successfully.")
        }
    }
    
    private func saveNote() {
        let trimmedNote = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNote.isEmpty else { return }
        
        guard let recipe = recipe else { return }
        
        let note = Note(
            content: trimmedNote,
            recipeId: recipe.id,
            recipeName: recipe.title
        )
        
        noteStore.addNote(note)
        noteText = ""
        showingNoteConfirmation = true
    }
}
