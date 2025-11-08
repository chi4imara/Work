import SwiftUI

struct StoryDetailView: View {
    let storyId: UUID
    @ObservedObject var viewModel: StoriesViewModel
    let onDismiss: () -> Void
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentStory: Story? {
        viewModel.stories.first { $0.id == storyId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if let story = currentStory {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(story.title)
                                .font(.appTitle)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(story.content)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineSpacing(4)
                            
                            if !story.tags.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Tags")
                                        .font(.cardTitle)
                                        .foregroundColor(.textPrimary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                        ForEach(story.tags, id: \.self) { tag in
                                            TagView(tag: tag, size: .medium)
                                        }
                                    }
                                }
                            }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(.cardTitle)
                                .foregroundColor(.textPrimary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Created:")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                    Spacer()
                                    Text(DateFormatter.fullDateTime.string(from: story.createdAt))
                                        .font(.caption)
                                        .foregroundColor(.textPrimary)
                                }
                                
                                if story.updatedAt != story.createdAt {
                                    HStack {
                                        Text("Updated:")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                        Spacer()
                                        Text(DateFormatter.fullDateTime.string(from: story.updatedAt))
                                            .font(.caption)
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                                
                                if story.viewCount > 0 {
                                    HStack {
                                        Text("Views:")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                        Spacer()
                                        Text("\(story.viewCount)")
                                            .font(.caption)
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                                
                                if let lastViewed = story.lastViewedAt {
                                    HStack {
                                        Text("Last viewed:")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                        Spacer()
                                        Text(DateFormatter.fullDateTime.string(from: lastViewed))
                                            .font(.caption)
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color.cardBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.borderColor, lineWidth: 1)
                            )
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Story")
                                }
                                .font(.buttonText)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.primaryBlue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Story")
                                }
                                .font(.buttonText)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red)
                                .cornerRadius(12)
                            }
                        }
                        
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
                            .foregroundColor(.textSecondary)
                        
                        Text("Story not found")
                            .font(.cardTitle)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            onDismiss()
                        }
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.primaryBlue)
                        .cornerRadius(20)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Story Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        onDismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let story = currentStory {
                StoryEditView(viewModel: viewModel, story: story)
            }
        }
        .alert("Delete Story", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let story = currentStory {
                    viewModel.deleteStory(story)
                    onDismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this story? This action cannot be undone.")
        }
    }
}

extension DateFormatter {
    static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    let viewModel = StoriesViewModel()
    let sampleStory = Story(
        title: "Sample Story",
        content: "This is a sample story content that demonstrates how the detail view looks with some text content.",
        tags: ["sample", "preview", "test"]
    )
    viewModel.addStory(sampleStory)
    
    return StoryDetailView(
        storyId: sampleStory.id,
        viewModel: viewModel
    ) {
        print("Dismiss")
    }
}
