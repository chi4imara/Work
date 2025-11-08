import SwiftUI

struct RandomIdeaView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var randomIdea: Idea?
    @State private var showingAnimation = false
    @State private var selectedIdea: Idea?
    @State private var ideaToEdit: Idea?
    
    var body: some View {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                        .disabled(true)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text("Random Idea")
                            .font(.theme.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                    }
                    .padding()
                    
                    VStack(spacing: 30) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppColors.primaryOrange.opacity(0.2),
                                            AppColors.primaryOrange.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(showingAnimation ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true), value: showingAnimation)
                            
                            Image(systemName: "dice.fill")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(AppColors.primaryOrange)
                                .rotationEffect(.degrees(showingAnimation ? 360 : 0))
                                .animation(.easeInOut(duration: 0.6).repeatCount(3, autoreverses: false), value: showingAnimation)
                        }
                        
                        if let idea = randomIdea {
                            VStack(spacing: 20) {
                                Text("Your Random Idea")
                                    .font(.theme.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                    .fontWeight(.bold)
                                
                                VStack(spacing: 16) {
                                    Text(idea.title)
                                        .font(.theme.title3)
                                        .foregroundColor(AppColors.textPrimary)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                    
                                    HStack {
                                        Text(idea.category)
                                            .font(.theme.caption1)
                                            .foregroundColor(AppColors.primaryOrange)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(AppColors.primaryOrange.opacity(0.15))
                                            )
                                        
                                        Spacer()
                                        
                                        Text(DateFormatter.shortDate.string(from: idea.dateAdded))
                                            .font(.theme.caption2)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    if !idea.note.isEmpty {
                                        Text(idea.note)
                                            .font(.theme.body)
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.vertical, 24)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                        .shadow(color: AppColors.primaryOrange.opacity(0.1), radius: 8, x: 0, y: 4)
                                )
                            }
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                        } else {
                            VStack(spacing: 16) {
                                Text("No Ideas Available")
                                    .font(.theme.title3)
                                    .foregroundColor(AppColors.textSecondary)
                                    .fontWeight(.medium)
                                
                                Text("Add some ideas first to get random suggestions")
                                    .font(.theme.body)
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                            .transition(.opacity)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                generateNewRandomIdea()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Another One")
                                        .font(.theme.buttonMedium)
                                }
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.primaryOrange.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.primaryOrange.opacity(0.4), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .disabled(viewModel.ideas.isEmpty)
                            
                            if let idea = randomIdea {
                                Button(action: {
                                    selectedIdea = idea
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "eye.fill")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("View Details")
                                            .font(.theme.buttonMedium)
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryOrange)
                                            .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 4, x: 0, y: 2)
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 6)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Random Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                }
            }
        .sheet(item: $ideaToEdit) { idea in
            AddEditIdeaView(viewModel: viewModel, ideaToEdit: idea)
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(ideaId: idea.id, viewModel: viewModel)
        }
        .onAppear {
            generateNewRandomIdea()
        }
    }
    
    private func generateNewRandomIdea() {
        withAnimation(.easeInOut(duration: 0.3)) {
            randomIdea = nil
        }
        
        showingAnimation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                randomIdea = viewModel.getRandomIdea()
                showingAnimation = false
            }
        }
    }
}


#Preview {
    RandomIdeaView(viewModel: IdeasViewModel())
}
