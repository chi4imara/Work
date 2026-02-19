import SwiftUI

struct ProjectSavedView: View {
    let project: Project
    @Binding var isPresented: Bool
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ColorManager.success)
                    .padding(.top, 40)
                
                Text("Project Saved")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                VStack(spacing: 16) {
                    ProjectInfoRow(title: "Project Name", value: project.name)
                    ProjectInfoRow(title: "Category", value: project.category)
                    ProjectInfoRow(title: "Start Date", value: DateFormatter.shortDate.string(from: project.startDate))
                    ProjectInfoRow(title: "Comment", value: project.comment.isEmpty ? "Comment not added." : project.comment)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                    onDone()
                }) {
                    Text("Done")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(ColorManager.primaryButton)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}

struct ProjectInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.primaryText.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(ColorManager.primaryText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    ProjectSavedView(
        project: Project(name: "Fix Compressor", category: "repair", startDate: Date(), comment: "Remove cover, replace belt"),
        isPresented: .constant(true),
        onDone: {}
    )
}
