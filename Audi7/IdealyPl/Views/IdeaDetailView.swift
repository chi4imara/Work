import SwiftUI

struct IdeaDetailView: View {
    let ideaId: UUID
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var idea: Idea? {
        viewModel.getIdea(byId: ideaId)
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("Idea")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        if let idea = idea {
                            Button(action: {
                                viewModel.toggleFavorite(ideaId: idea.id)
                            }) {
                                Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(idea.isFavorite ? AppColors.accentYellow : AppColors.primaryText)
                            }
                        }
                        
                        Menu {
                            Button("Edit") {
                                showingEditView = true
                            }
                            
                            Button("Delete", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                if let idea = idea {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(idea.text)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.primaryText)
                                    .lineSpacing(4)
                                
                                HStack {
                                    Text("Created: \(idea.formattedDate)")
                                        .font(.ubuntu(12))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Spacer()
                                }
                            }
                            .padding(20)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                            )
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "pencil")
                                        Text("Edit")
                                    }
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.buttonText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(AppColors.buttonBackground)
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Idea not found")
                            .font(.ubuntu(18))
                            .foregroundColor(AppColors.secondaryText)
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let idea = idea {
                EditIdeaView(idea: idea, viewModel: viewModel)
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteIdea(byId: ideaId)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
    }
}
