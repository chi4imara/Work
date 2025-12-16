import SwiftUI

struct ThoughtDetailView: View {
    let thought: Thought
    let onUpdate: (Thought) -> Void
    let onDelete: (Thought) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(AppColors.yellow)
                                
                                Text(thought.dateString)
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                if thought.isEdited {
                                    Text("• edited")
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                                .background(AppColors.white.opacity(0.3))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(AppColors.yellow)
                                
                                Text("Your Thought")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                            }
                            
                            Text(thought.text)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                                .lineSpacing(4)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(20)
                        .background(AppColors.cardGradient)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
                        )
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Edit")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(AppColors.skyBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.white)
                                .cornerRadius(25)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: {
                                showingDeleteConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Delete")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(AppColors.coral)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.white.opacity(0.2))
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(AppColors.coral.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Thought Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showingEditView) {
            AddEditThoughtView(thought: thought)
        }
        .alert("Delete Thought", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete(thought)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this thought?")
        }
    }
}

#Preview {
    ThoughtDetailView(
        thought: Thought(text: "Today I realized that happiness isn't about having everything perfect, but about finding joy in the small moments that make life beautiful."),
        onUpdate: { _ in },
        onDelete: { _ in }
    )
}
