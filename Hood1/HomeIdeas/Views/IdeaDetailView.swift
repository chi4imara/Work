import SwiftUI

struct IdeaDetailView: View {
    let ideaId: UUID
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var idea: Idea? {
        viewModel.ideas.first { $0.id == ideaId }
    }
    
    var body: some View {
        return
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("Idea Details")
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                    .disabled(true)
                    .opacity(0)
                }
                .padding()
                
                if let idea = idea {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(idea.title)
                                    .font(.theme.largeTitle)
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            VStack(spacing: 15) {
                                InfoCardView(
                                    title: "Category",
                                    value: idea.category,
                                    icon: "folder.fill"
                                )
                                
                                InfoCardView(
                                    title: "Date Added",
                                    value: DateFormatter.fullDate.string(from: idea.dateAdded),
                                    icon: "calendar"
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "note.text")
                                        .font(.title3)
                                        .foregroundColor(AppColors.primaryOrange)
                                    
                                    Text("Note")
                                        .font(.theme.headline)
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                Text(idea.note.isEmpty ? "No notes added" : idea.note)
                                    .font(.theme.body)
                                    .foregroundColor(idea.note.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                                    .padding(15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Button(action: { showingEditView = true }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.title3)
                                        
                                        Text("Edit Idea")
                                            .font(.theme.buttonLarge)
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(AppColors.primaryOrange)
                                    .cornerRadius(12)
                                    .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.title3)
                                        
                                        Text("Delete Idea")
                                            .font(.theme.buttonLarge)
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(AppColors.buttonDanger)
                                    .cornerRadius(12)
                                    .shadow(color: AppColors.buttonDanger.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                            }
                            .padding(.top, 10)
                            
                            Spacer(minLength: 50)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("Idea Not Found")
                            .font(.theme.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("This idea may have been deleted")
                            .font(.theme.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            dismiss()
                        }
                        .font(.theme.buttonMedium)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryOrange)
                        .cornerRadius(20)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let idea = idea {
                AddEditIdeaView(viewModel: viewModel, ideaToEdit: idea)
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let idea = idea {
                    viewModel.deleteIdea(idea)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let idea = idea {
                Text("Are you sure you want to delete '\(idea.title)'? This action cannot be undone.")
            }
        }
    }
}

struct InfoCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryOrange.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.theme.caption1)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(value)
                    .font(.theme.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(15)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    let sampleIdea = Idea(
        title: "Read a book",
        category: "Quiet Leisure",
        note: "30 minutes of novel reading"
    )
    let viewModel = IdeasViewModel()
    viewModel.addIdea(sampleIdea)
    
    return IdeaDetailView(
        ideaId: sampleIdea.id,
        viewModel: viewModel
    )
}
