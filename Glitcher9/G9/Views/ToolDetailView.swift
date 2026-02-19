import SwiftUI

struct ToolDetailView: View {
    let tool: Tool
    @ObservedObject var toolsViewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppColors.buttonGradient)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: toolIcon(for: tool.type))
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.appWhite)
                        }
                        
                        Text(tool.name)
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(.appWhite)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        DetailCard(title: "Type", value: tool.type, icon: "folder")
                        DetailCard(title: "Condition", value: tool.condition, icon: "checkmark.shield")
                        DetailCard(
                            title: "Comment",
                            value: tool.comment.isEmpty ? "No comment added." : tool.comment,
                            icon: "text.bubble"
                        )
                        DetailCard(
                            title: "Date Added",
                            value: DateFormatter.shortDate.string(from: tool.dateCreated),
                            icon: "calendar"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Edit Tool")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.appWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Delete Tool")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.appWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.accentGradient)
                            .cornerRadius(16)
                            .shadow(color: AppColors.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.playfairDisplay(size: 16, weight: .medium))
                    }
                    .foregroundColor(.appLightBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditToolView(tool: tool, toolsViewModel: toolsViewModel)
        }
        .alert("Delete Tool", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                toolsViewModel.deleteTool(tool)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(tool.name)'? This action cannot be undone.")
        }
    }
    
    private func toolIcon(for type: String) -> String {
        switch type.lowercased() {
        case let t where t.contains("mechanical") || t.contains("mechanic"):
            return "wrench.and.screwdriver"
        case let t where t.contains("wood") || t.contains("timber"):
            return "hammer"
        case let t where t.contains("electrical") || t.contains("electric"):
            return "bolt"
        default:
            return "wrench.and.screwdriver"
        }
    }
}

struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.lightBlue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appLightBlue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
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
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NavigationView {
        ToolDetailView(
            tool: Tool(name: "Hammer", type: "Mechanical", condition: "New", comment: "Heavy duty hammer"),
            toolsViewModel: ToolsViewModel()
        )
    }
}
