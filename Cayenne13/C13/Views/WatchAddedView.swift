import SwiftUI

struct WatchAddedView: View {
    let watch: Watch
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(ColorManager.green)
                        .shadow(color: ColorManager.green.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("Watch Added")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                }
                .padding(.top, 50)
                
                VStack(spacing: 20) {
                    WatchDetailRow(title: "Name / Model", value: watch.name)
                    WatchDetailRow(title: "Purchase Date", value: formatDate(watch.purchaseDate))
                    WatchDetailRow(title: "Style", value: watch.style.displayName)
                    WatchDetailRow(title: "Condition", value: watch.condition.displayName)
                    WatchDetailRow(
                        title: "Comment",
                        value: watch.comment.isEmpty ? "No comment added." : watch.comment
                    )
                }
                .padding(20)
                .background(ColorManager.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                    onDismiss()
                }) {
                    HStack {
                        Text("Done")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.white)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorManager.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [ColorManager.lightBlue, ColorManager.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
                    .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct WatchDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(ColorManager.accentText)
            
            Text(value)
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WatchAddedView(
        watch: Watch(
            name: "Casio Edifice",
            purchaseDate: Date(),
            style: .sport,
            condition: .new,
            comment: "Birthday gift"
        ),
        isPresented: .constant(true),
        onDismiss: {}
    )
}
