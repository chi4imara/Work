import SwiftUI

struct ArchivedInstructionDetailView: View {
    let instruction: RepairInstruction
    @ObservedObject var viewModel: RepairInstructionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        
                        toolsSection
                        
                        stepsSection
                        
                        if !instruction.tips.isEmpty {
                            tipsSection
                        }
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.textSecondary.opacity(0.3), Color.textSecondary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                Image(systemName: instruction.category.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(instruction.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textSecondary)
                
                Text(instruction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                
                Text(instruction.shortDescription)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .lineLimit(nil)
                
                if let dateArchived = instruction.dateArchived {
                    Text("Archived on \(dateArchived, style: .date)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What You'll Need")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 10) {
                ForEach(Array(instruction.tools.enumerated()), id: \.offset) { index, tool in
                    HStack {
                        Image(systemName: "square")
                            .font(.title3)
                            .foregroundColor(.textSecondary)
                        
                        Text(tool)
                            .font(.body)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(Color.cardBackground.opacity(0.5))
            .cornerRadius(12)
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Step-by-Step Instructions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 15) {
                ForEach(Array(instruction.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(Color.textSecondary.opacity(0.3))
                                .frame(width: 30, height: 30)
                            
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.textSecondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(step.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textSecondary)
                            
                            Text(step.description)
                                .font(.body)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.cardBackground.opacity(0.3))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tips & Safety")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 10) {
                ForEach(Array(instruction.tips.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top) {
                        Image(systemName: "lightbulb.fill")
                            .font(.body)
                            .foregroundColor(.textSecondary)
                        
                        Text(tip)
                            .font(.body)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(Color.textSecondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
            }) {
                HStack {
                    Image(systemName: "star")
                    Text("Add to Favorites")
                }
                .font(.headline)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.textSecondary.opacity(0.2))
                .cornerRadius(12)
            }
            .disabled(true)
            
            Button(action: {
                viewModel.restoreInstruction(instruction)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Move to Handbook")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentGreen)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    ArchivedInstructionDetailView(
        instruction: RepairInstruction(
            title: "Fix Leaking Faucet",
            category: .plumbing,
            shortDescription: "How to repair a dripping tap in your kitchen or bathroom",
            imageName: "faucet",
            tools: ["Adjustable wrench", "Screwdriver", "Plumber's tape"],
            steps: [
                RepairStep(title: "Turn off water supply", description: "Locate the shut-off valve under the sink and turn it clockwise."),
                RepairStep(title: "Remove faucet handle", description: "Use a screwdriver to remove the screw holding the handle.")
            ],
            tips: ["Always turn off water supply before starting", "Keep track of small parts"]
        ),
        viewModel: RepairInstructionViewModel()
    )
}
