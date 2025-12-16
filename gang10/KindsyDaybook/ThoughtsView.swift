import SwiftUI

struct ThoughtsView: View {
    @StateObject private var viewModel = ThoughtsViewModel()
    @State private var bubbles: [MovingBubble] = []
    
    var body: some View {
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
            
            VStack {
                HStack {
                    Text("My Thoughts")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showingAddThought = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
                
                if viewModel.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.thoughts) { thought in
                                ThoughtCardView(thought: thought) {
                                    viewModel.showingThoughtDetail = ThoughtDetailID(id: thought.id)
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .onAppear {
            generateBubbles()
        }
        .sheet(isPresented: $viewModel.showingAddThought) {
            AddEditThoughtView()
        }
        .sheet(item: $viewModel.showingThoughtDetail) { thoughtDetailID in
            if let thought = viewModel.thoughts.first(where: { $0.id == thoughtDetailID.id }) {
                ThoughtDetailView(thought: thought) { updatedThought in
                } onDelete: { thoughtToDelete in
                    viewModel.deleteThought(thoughtToDelete)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "pencil")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 12) {
                Text("It's quiet here.")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Write your first thought.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                viewModel.showingAddThought = true
            }) {
                Text("Add Record")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.skyBlue)
                    .frame(width: 200, height: 50)
                    .background(AppColors.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func generateBubbles() {
        bubbles = (0..<8).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...45),
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

struct ThoughtCardView: View {
    let thought: Thought
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(thought.title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Text(thought.preview)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(thought.dateString)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                    
                    if thought.isEdited {
                        Text("• edited")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ThoughtsView()
}
