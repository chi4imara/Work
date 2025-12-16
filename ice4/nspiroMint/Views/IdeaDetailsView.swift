import SwiftUI

struct IdeaDetailsView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    let ideaId: UUID
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var idea: HobbyIdea? {
        viewModel.getIdea(by: ideaId)
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                HStack {
                                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("Idea Details")
                                        .font(.playfairDisplay(24, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Color.clear
                                        .frame(width: 24, height: 24)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        HStack(spacing: 8) {
                                            Image(systemName: idea.hobby.icon)
                                                .font(.system(size: 16, weight: .semibold))
                                            Text(idea.hobby.displayName)
                                                .font(.playfairDisplay(16, weight: .semibold))
                                        }
                                        .foregroundColor(AppColors.primaryYellow)
                                        
                                        Spacer()
                                        
                                        Text(formatDate(idea.dateCreated))
                                            .font(.playfairDisplay(14, weight: .regular))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    
                                    Text(idea.title)
                                        .font(.playfairDisplay(28, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 16, weight: .regular))
                                        Text(idea.mood)
                                            .font(.playfairDisplay(16, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.accentPink)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Description")
                                            .font(.playfairDisplay(18, weight: .semibold))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Text(idea.description)
                                            .font(.playfairDisplay(16, weight: .regular))
                                            .foregroundColor(AppColors.secondaryText)
                                            .lineSpacing(4)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(24)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(AppColors.cardGradient)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 20)
                                
                                VStack(spacing: 16) {
                                    if !idea.isFavorite {
                                        Button(action: { 
                                            viewModel.toggleFavorite(idea)
                                        }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: "heart")
                                                    .font(.system(size: 18, weight: .semibold))
                                                Text("Add to Favorites")
                                                    .font(.playfairDisplay(18, weight: .semibold))
                                            }
                                            .foregroundColor(AppColors.buttonText)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(AppColors.accentPink)
                                            )
                                        }
                                    }
                                    
                                    HStack(spacing: 16) {
                                        Button(action: { showingEditView = true }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "pencil")
                                                    .font(.system(size: 16, weight: .semibold))
                                                Text("Edit")
                                                    .font(.playfairDisplay(16, weight: .semibold))
                                            }
                                            .foregroundColor(AppColors.buttonText)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(AppColors.accentOrange)
                                            )
                                        }
                                        
                                        Button(action: { showingDeleteAlert = true }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 16, weight: .semibold))
                                                Text("Delete")
                                                    .font(.playfairDisplay(16, weight: .semibold))
                                            }
                                            .foregroundColor(AppColors.primaryWhite)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.red.opacity(0.8))
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showingEditView) {
                    NewIdeaView(viewModel: viewModel, editingIdea: idea)
                }
                .alert("Delete Idea", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteIdea(idea)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this idea? This action cannot be undone.")
                }
            } else {
                Text("Idea not found")
                    .font(.playfairDisplay(18, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    let viewModel = HobbyIdeaViewModel()
    let sampleIdea = HobbyIdea(
        hobby: .drawing,
        title: "Abstract landscape painting",
        description: "Create an abstract interpretation of a mountain landscape using bold colors and geometric shapes. Focus on capturing the essence rather than realistic details.",
        mood: "Peaceful"
    )
    viewModel.addIdea(sampleIdea)
    
    return IdeaDetailsView(viewModel: viewModel, ideaId: sampleIdea.id)
}
