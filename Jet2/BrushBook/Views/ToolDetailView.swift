import SwiftUI

struct ToolDetailView: View {
    @EnvironmentObject var viewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let tool: Tool
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    toolInfoCard
                    
                    commentSection
                    
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditSheet) {
            AddToolView(toolToEdit: tool)
                .environmentObject(viewModel)
        }
        .alert("Delete Tool", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTool(tool)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this tool? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
            
            Spacer()
            
            Text("Tool Details")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Menu {
                Button(action: { showingEditSheet = true }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
        }
        .padding(.top, 10)
    }
    
    private var toolInfoCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(ColorManager.cardGradient)
                        .frame(width: 80, height: 80)
                        .shadow(color: ColorManager.cardShadow, radius: 15, x: 0, y: 8)
                    
                    Image(systemName: iconForCategory(tool.category))
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                VStack(spacing: 4) {
                    Text(tool.name)
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(tool.category.displayName)
                        .font(.playfairDisplay(16))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            
            VStack(spacing: 16) {
                DetailRow(
                    title: "Purchase Date",
                    value: tool.purchaseDate.formatted(date: .long, time: .omitted),
                    icon: "calendar"
                )
                
                DetailRow(
                    title: "Condition",
                    value: tool.actualCondition.displayName,
                    icon: "checkmark.circle.fill",
                    valueColor: tool.actualCondition.color
                )
                
                if tool.isOld && tool.condition != .needsReplacement {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        
                        Text("This tool is over 12 months old and may need replacement")
                            .font(.playfairDisplay(14))
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                let daysSincePurchase = Calendar.current.dateComponents([.day], from: tool.purchaseDate, to: Date()).day ?? 0
                DetailRow(
                    title: "Days Since Purchase",
                    value: "\(daysSincePurchase) days",
                    icon: "clock"
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.shadowColor, radius: 15, x: 0, y: 8)
        )
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            if tool.comment.isEmpty {
                Text("No comment added. You can add one by editing this tool.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .italic()
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            } else {
                Text(tool.comment)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showingEditSheet = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit Tool")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(ColorManager.primaryButton)
                .cornerRadius(26)
                .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete Tool")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.top, 20)
    }
    
    private func iconForCategory(_ category: ToolCategory) -> String {
        switch category {
        case .brushes: return "paintbrush.pointed.fill"
        case .sponges: return "circle.fill"
        case .curlers: return "waveform"
        case .tweezers: return "scissors"
        case .other: return "wrench.and.screwdriver.fill"
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    var valueColor: Color = ColorManager.primaryText
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(ColorManager.secondaryText)
                .frame(width: 24)
            
            Text(title)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(valueColor)
        }
    }
}
