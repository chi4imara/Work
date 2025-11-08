import SwiftUI

struct IdeaDetailView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    let idea: InteriorIdea
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var currentIdea: InteriorIdea
    
    init(viewModel: InteriorIdeasViewModel, idea: InteriorIdea) {
        self.viewModel = viewModel
        self.idea = idea
        self._currentIdea = State(initialValue: idea)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                        
                        Spacer()
                        
                        Text("Idea Details")
                            .font(AppFonts.title2())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: toggleFavorite) {
                            Image(systemName: currentIdea.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 6)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(currentIdea.title)
                                        .font(AppFonts.title1())
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(currentIdea.category.rawValue)
                                        .font(AppFonts.subheadline())
                                        .foregroundColor(AppColors.primaryOrange)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Note")
                                    .font(AppFonts.headline())
                                    .foregroundColor(AppColors.primaryText)
                                
                                if currentIdea.note.isEmpty {
                                    Text("No note available")
                                        .font(AppFonts.body())
                                        .foregroundColor(AppColors.tertiaryText)
                                        .italic()
                                } else {
                                    Text(currentIdea.note)
                                        .font(AppFonts.body())
                                        .foregroundColor(AppColors.secondaryText)
                                        .lineSpacing(4)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Details")
                                    .font(AppFonts.headline())
                                    .foregroundColor(AppColors.primaryText)
                                
                                VStack(spacing: 8) {
                                    DetailRow(
                                        title: "Date Added",
                                        value: formatDate(currentIdea.dateAdded)
                                    )
                                    
                                    if currentIdea.dateModified != currentIdea.dateAdded {
                                        DetailRow(
                                            title: "Last Modified",
                                            value: formatDate(currentIdea.dateModified)
                                        )
                                    }
                                    
                                    DetailRow(
                                        title: "Category",
                                        value: currentIdea.category.rawValue
                                    )
                                    
                                    DetailRow(
                                        title: "Favorite",
                                        value: currentIdea.isFavorite ? "Yes" : "No"
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 120)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete")
                                    .font(AppFonts.button())
                            }
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.error)
                            .cornerRadius(25)
                        }
                        
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit")
                                    .font(AppFonts.button())
                            }
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppGradients.buttonGradient)
                            .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            updateCurrentIdea()
        }
        .sheet(isPresented: $showingEditView) {
            AddEditIdeaView(viewModel: viewModel, ideaToEdit: currentIdea)
                .onDisappear {
                    updateCurrentIdea()
                }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteIdea(currentIdea)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
    }
    
    private func toggleFavorite() {
        viewModel.toggleFavorite(for: currentIdea)
        updateCurrentIdea()
    }
    
    private func updateCurrentIdea() {
        if let updatedIdea = viewModel.ideas.first(where: { $0.id == idea.id }) {
            currentIdea = updatedIdea
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.callout())
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.callout())
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let viewModel = InteriorIdeasViewModel()
    let sampleIdea = InteriorIdea(
        title: "Modern Living Room",
        category: .livingRoom,
        note: "A beautiful modern living room with minimalist design and neutral colors. Features include a comfortable sectional sofa, glass coffee table, and ambient lighting.",
        isFavorite: true
    )
    
    return IdeaDetailView(viewModel: viewModel, idea: sampleIdea)
}
