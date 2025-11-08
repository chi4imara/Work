import SwiftUI

#if DEBUG
struct StoryUpdateTest: View {
    @StateObject private var viewModel = StoriesViewModel()
    @State private var testStory: Story?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Story Update Test")
                .font(.screenTitle)
            
            if let story = testStory {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Story:")
                        .font(.cardTitle)
                    
                    Text("Title: \(story.title)")
                        .font(.bodyText)
                    
                    Text("Content: \(story.content)")
                        .font(.bodyText)
                    
                    Text("Tags: \(story.tags.joined(separator: ", "))")
                        .font(.bodyText)
                    
                    Text("Updated: \(DateFormatter.shortDate.string(from: story.updatedAt))")
                        .font(.caption)
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(8)
            }
            
            Button("Create Test Story") {
                let story = Story(
                    title: "Test Story",
                    content: "This is a test story for updating.",
                    tags: ["test", "debug"]
                )
                viewModel.addStory(story)
                testStory = story
            }
            .font(.buttonText)
            .foregroundColor(.white)
            .padding()
            .background(Color.primaryBlue)
            .cornerRadius(8)
            
            Button("Update Story") {
                if var story = testStory {
                    story.updateContent(
                        title: "Updated Test Story",
                        content: "This story has been updated!",
                        tags: ["test", "debug", "updated"]
                    )
                    viewModel.updateStory(story)
                    testStory = story
                }
            }
            .font(.buttonText)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .disabled(testStory == nil)
            
            Button("Refresh from ViewModel") {
                if let story = testStory {
                    testStory = viewModel.stories.first { $0.id == story.id }
                }
            }
            .font(.buttonText)
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(8)
            .disabled(testStory == nil)
        }
        .padding()
    }
}

#Preview {
    StoryUpdateTest()
}
#endif
