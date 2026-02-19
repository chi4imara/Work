import SwiftUI

struct ToolSavedView: View {
    let tool: Tool
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.softGreen.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .fill(AppColors.softGreen)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.appWhite)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                }
                
                Text("Tool Saved!")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.appWhite)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                
                VStack(spacing: 16) {
                    ToolDetailRow(title: "Name", value: tool.name, icon: "wrench.and.screwdriver")
                    ToolDetailRow(title: "Type", value: tool.type, icon: "folder")
                    ToolDetailRow(title: "Condition", value: tool.condition, icon: "checkmark.shield")
                    ToolDetailRow(
                        title: "Comment",
                        value: tool.comment.isEmpty ? "No comment added." : tool.comment,
                        icon: "text.bubble"
                    )
                }
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 30)
                
                Spacer()
                
                Button(action: {
                    onDismiss()
                    isPresented = false
                }) {
                    HStack {
                        Text("Done")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.buttonGradient)
                    .cornerRadius(16)
                    .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 40)
                
                Spacer(minLength: 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            }
        }
    }
}

struct ToolDetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appLightBlue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(.appLightBlue)
                
                Text(value)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(.appWhite)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ToolSavedView(
        tool: Tool(name: "Hammer", type: "Mechanical", condition: "New", comment: "Heavy duty hammer for construction work"),
        isPresented: .constant(true),
        onDismiss: {}
    )
}
