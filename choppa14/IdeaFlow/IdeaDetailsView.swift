import SwiftUI

struct IdeaDetailsView: View {
    let ideaID: UUID
    @ObservedObject var viewModel: ContentIdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var idea: ContentIdea? {
        viewModel.getIdea(by: ideaID)
    }
    
    private var currentStatus: ContentStatus {
        idea?.status ?? .idea
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                NavigationView {
                    ZStack {
                        Color.theme.primaryGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerSection(idea: idea)
                                
                                contentSection(idea: idea)
                                
                                statusSection(idea: idea)
                                
                                actionButtons(idea: idea)
                                
                                Spacer(minLength: 50)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(idea.title)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(Color.theme.accentText)
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    IdeaCreationView(viewModel: viewModel, editingIdea: idea)
                }
                .alert("Delete Idea", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteIdea(idea)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete \"\(idea.title)\"?")
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private func headerSection(idea: ContentIdea) -> some View {
        VStack(spacing: 16) {
            Image(systemName: idea.contentType.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.primaryBlue)
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .fill(Color.theme.lightBlue.opacity(0.2))
                )
            
            VStack(spacing: 8) {
                Text(idea.contentType.displayName)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(Color.theme.accentText)
                
                Text("Created \(idea.createdDate, style: .date)")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.shadowColor, radius: 10, x: 0, y: 5)
        )
    }
    
    private func contentSection(idea: ContentIdea) -> some View {
        VStack(spacing: 20) {
            DetailRow(
                title: "Description",
                content: idea.description.isEmpty ? "Description not added. You can specify scenario details or shooting location." : idea.description,
                isPlaceholder: idea.description.isEmpty
            )
            
            if let publishDate = idea.publishDate {
                DetailRow(
                    title: "Publish Date",
                    content: publishDate.formatted(date: .abbreviated, time: .omitted)
                )
            }
            
            if !idea.hashtags.isEmpty {
                DetailRow(
                    title: "Hashtags",
                    content: idea.hashtags
                )
            }
        }
    }
    
    private func statusSection(idea: ContentIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            Menu {
                ForEach(ContentStatus.allCases, id: \.self) { status in
                    Button(action: {
                        updateStatus(to: status, for: idea)
                    }) {
                        HStack {
                            Text(status.displayName)
                            if currentStatus == status {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Circle()
                        .fill(currentStatus.color)
                        .frame(width: 16, height: 16)
                    
                    Text(currentStatus.displayName)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.theme.cardGradient)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func actionButtons(idea: ContentIdea) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.theme.purpleGradient)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.red, Color.red.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
        }
    }
    
    private func updateStatus(to newStatus: ContentStatus, for idea: ContentIdea) {
        let updatedIdea = ContentIdea(
            id: idea.id,
            title: idea.title,
            contentType: idea.contentType,
            description: idea.description,
            publishDate: idea.publishDate,
            status: newStatus,
            hashtags: idea.hashtags,
            createdDate: idea.createdDate
        )
        viewModel.updateIdea(updatedIdea)
    }
}

struct DetailRow: View {
    let title: String
    let content: String
    var isPlaceholder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(content)
                .font(.playfairDisplay(15, weight: .regular))
                .foregroundColor(isPlaceholder ? Color.theme.secondaryText : Color.theme.primaryText)
                .opacity(isPlaceholder ? 0.7 : 1.0)
                .italic(isPlaceholder)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    let viewModel = ContentIdeasViewModel()
    let sampleIdea = ContentIdea(
        title: "Morning Coffee",
        contentType: .photo,
        description: "Flat lay with coffee cup and laptop on table.",
        publishDate: Date(),
        status: .idea,
        hashtags: "#coffee #morning #aesthetic"
    )
    viewModel.addIdea(sampleIdea)
    
    return IdeaDetailsView(ideaID: sampleIdea.id, viewModel: viewModel)
}
