import SwiftUI

struct RitualDetailView: View {
    @ObservedObject var viewModel: RitualViewModel
    let ritualId: UUID
    @State private var showMarkCompletion = false
    @State private var showEditRitual = false
    
    private var ritual: Ritual? {
        viewModel.getRitual(by: ritualId)
    }
    
    var body: some View {
        Group {
            if let ritual = ritual {
                ritualDetailContent(ritual: ritual)
            } else {
                Text("Ritual not found")
                    .font(.appBody())
                    .foregroundColor(AppColors.textWhite)
            }
        }
    }
    
    private func ritualDetailContent(ritual: Ritual) -> some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(ritual.title)
                            .font(.appTitle())
                            .foregroundColor(AppColors.textWhite)
                        
                        Text(ritual.description)
                            .font(.appBody())
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    
                    HStack {
                        Text(ritual.isRepeating ? "Repeating Ritual" : "One-time Ritual")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            showMarkCompletion = true
                        }) {
                            Text("Mark Completion")
                                .font(.appButton())
                                .foregroundColor(AppColors.textWhite)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.accentPurple)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showEditRitual = true
                        }) {
                            Text("Edit")
                                .font(.appButton())
                                .foregroundColor(AppColors.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.buttonBackground)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle(ritual.title)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showMarkCompletion) {
            MarkCompletionView(viewModel: viewModel, ritualId: ritual.id)
        }
        .sheet(isPresented: $showEditRitual) {
            EditRitualView(viewModel: viewModel, ritualId: ritual.id)
        }
    }
}

struct MarkCompletionView: View {
    @ObservedObject var viewModel: RitualViewModel
    let ritualId: UUID
    @Environment(\.dismiss) var dismiss
    
    private var ritual: Ritual? {
        viewModel.getRitual(by: ritualId)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Did you complete this ritual today?")
                        .font(.appHeadline())
                        .foregroundColor(AppColors.textWhite)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            viewModel.markCompletion(for: ritualId)
                            dismiss()
                        }) {
                            Text("Yes, marked")
                                .font(.appButton())
                                .foregroundColor(AppColors.textWhite)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.accentPurple)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(.appButton())
                                .foregroundColor(AppColors.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.buttonBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
            .navigationTitle("Mark Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .font(.appHeadline())
            .foregroundColor(AppColors.textWhite)
        }
    }
}
