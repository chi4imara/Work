import SwiftUI

struct ToolAddedView: View {
    let tool: Tool
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(AppColors.success.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(AppColors.success)
                }
                
                Text("Tool Added")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 15) {
                    InfoRow(title: "Name", value: tool.name)
                    InfoRow(title: "Storage Location", value: tool.storageLocation)
                    InfoRow(title: "Category", value: tool.category.rawValue)
                    InfoRow(title: "Comment", value: tool.comment.isEmpty ? "Comment not added." : tool.comment)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                    onDismiss()
                }) {
                    Text("Done")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.lightBlue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
            .padding(.top, 50)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ToolAddedView(
        tool: Tool(name: "Drill", storageLocation: "Garage", category: .electric, comment: "Test comment"),
        isPresented: .constant(true),
        onDismiss: {}
    )
}
