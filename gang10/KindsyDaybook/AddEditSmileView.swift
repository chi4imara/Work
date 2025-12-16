import SwiftUI

struct AddEditSmileView: View {
    @StateObject private var viewModel = AddEditSmileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var bubbles: [MovingBubble] = []
    
    var smile: Smile?
    
    init(smile: Smile? = nil) {
        self.smile = smile
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles, id: \.id) { bubble in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                        .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Share your moment")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .frame(minHeight: 200)
                                
                                if viewModel.text.isEmpty {
                                    Text("Who smiled? Where was it? What did you feel?")
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $viewModel.text)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .background(Color.clear)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(AppColors.yellow)
                            
                            Text(viewModel.currentDateTime)
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                viewModel.save()
                                dismiss()
                            }) {
                                Text("Save Smile")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(viewModel.canSave ? AppColors.skyBlue : AppColors.skyBlue.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(viewModel.canSave ? AppColors.white : AppColors.white.opacity(0.5))
                                    .cornerRadius(25)
                                    .shadow(color: Color.black.opacity(viewModel.canSave ? 0.1 : 0.05), radius: 8, x: 0, y: 4)
                            }
                            .disabled(!viewModel.canSave)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Smile" : "New Smile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            viewModel.setup(for: smile)
            generateBubbles()
        }
        .alert("Delete Smile", isPresented: $viewModel.showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                viewModel.delete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this smile?")
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<8).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 15...40),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 15...30)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
    }
}

#Preview {
    AddEditSmileView()
}

