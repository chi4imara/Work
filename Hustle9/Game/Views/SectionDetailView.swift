import SwiftUI

struct SectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GameDetailViewModel
    
    let section: GameSection
    @State private var showingEditSection = false
    @State private var showingDeleteAlert = false
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(section.content)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit Section") {
                        showingEditSection = true
                    }
                    
                    Button("Delete Section", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showingEditSection) {
            AddEditSectionView(section: section, gameId: viewModel.game.id, viewModel: viewModel)
        }
        .alert("Delete Section", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
                    viewModel.deleteSection(at: index)
                    showToast("Section deleted")
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete \"\(section.title)\"? This action cannot be undone.")
        }
        .overlay(
            toastView,
            alignment: .top
        )
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(3)
            
            Text("Last modified: \(section.dateModified.formatted(date: .abbreviated, time: .shortened))")
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var toastView: some View {
        Group {
            if showingToast {
                Text(toastMessage)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.success)
                    )
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingToast = false
            }
        }
    }
}

#Preview {
    NavigationView {
        ZStack {
            BackgroundView()
            SectionDetailView(
                viewModel: GameDetailViewModel(
                    game: Game(name: "Test Game", category: .other),
                    gamesViewModel: GamesViewModel()
                ),
                section: GameSection(title: "Setup", content: "Place the board in the center of the table. Each player chooses a token and places it on the GO square. Shuffle the Chance and Community Chest cards and place them face down on their respective spaces on the board."),
            )
        }
    }
}
