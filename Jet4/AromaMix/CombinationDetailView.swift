import SwiftUI

struct CombinationDetailView: View {
    let combinationId: UUID
    @ObservedObject var viewModel: ScentCombinationsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var combination: ScentCombination? {
        viewModel.combinations.first(where: { $0.id == combinationId })
    }
    
    var body: some View {
        Group {
            if let combination = combination {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerCard(combination: combination)
                                
                                detailsSection(combination: combination)
                                
                                actionsSection(combination: combination)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                        }
                    }
                    .navigationTitle("Combination Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.blueText)
                    )
                }
                .sheet(isPresented: $showingEditView) {
                    AddCombinationView(viewModel: viewModel, existingCombination: combination)
                }
                .alert("Delete Combination", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteCombination(combination)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this combination? This action cannot be undone.")
                }
            }
        }
    }
    
    private func headerCard(combination: ScentCombination) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(combination.name)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: combination.category.icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.blueText)
                    
                    Text("\(combination.category.displayName) combination")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.blueText)
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: combination.rating.icon)
                    .font(.system(size: 20))
                    .foregroundColor(ratingColor(for: combination.rating))
                
                Text(combination.rating.displayName)
                    .font(AppFonts.headline)
                    .foregroundColor(ratingColor(for: combination.rating))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ratingColor(for: combination.rating).opacity(0.1))
            .cornerRadius(20)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func detailsSection(combination: ScentCombination) -> some View {
        VStack(spacing: 16) {
            DetailCard(
                title: "Perfume Aroma",
                content: combination.perfumeAroma,
                icon: "sparkles"
            )
            
            DetailCard(
                title: "Candle Aroma",
                content: combination.candleAroma,
                icon: "flame"
            )
            
            DetailCard(
                title: "Comment",
                content: combination.comment.isEmpty ? 
                    "No comment added. You can add one later through editing." : 
                    combination.comment,
                icon: "text.bubble",
                isPlaceholder: combination.comment.isEmpty
            )
            
            DetailCard(
                title: "Created",
                content: DateFormatter.displayFormatter.string(from: combination.dateCreated),
                icon: "calendar"
            )
        }
    }
    
    private func actionsSection(combination: ScentCombination) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Combination")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Combination")
                }
                .font(AppFonts.headline)
                .foregroundColor(AppColors.warningRed)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white.opacity(0.8))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.warningRed, lineWidth: 1)
                )
            }
        }
    }
    
    private func ratingColor(for rating: Rating) -> Color {
        switch rating {
        case .favorite: return AppColors.warningRed
        case .good: return AppColors.successGreen
        case .trial: return AppColors.yellowAccent
        }
    }
}

struct DetailCard: View {
    let title: String
    let content: String
    let icon: String
    var isPlaceholder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.blueText)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
            }
            
            Text(content)
                .font(AppFonts.body)
                .foregroundColor(isPlaceholder ? AppColors.darkGray.opacity(0.6) : AppColors.darkGray)
                .italic(isPlaceholder)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    let viewModel = ScentCombinationsViewModel()
    let combination = ScentCombination(
        name: "Vanilla & Sandalwood",
        category: .warm,
        perfumeAroma: "YSL Black Opium",
        candleAroma: "Diptyque Vanille",
        comment: "Perfect for cozy autumn evenings",
        rating: .favorite
    )
    viewModel.addCombination(combination)
    return CombinationDetailView(
        combinationId: combination.id,
        viewModel: viewModel
    )
}
