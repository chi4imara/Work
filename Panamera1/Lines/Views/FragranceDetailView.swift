import SwiftUI

struct FragranceDetailView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let fragranceId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentFragrance: Fragrance? {
        viewModel.getFragrance(by: fragranceId)
    }
    
    var body: some View {
        Group {
            if let fragrance = currentFragrance {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(fragrance.name)
                                        .font(.bellGothicBold(size: 24))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(fragrance.brand)
                                        .font(.bellGothicRegular(size: 18))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                
                                Divider()
                                    .background(AppColors.separatorColor)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Season")
                                            .font(.bellGothicRegular(size: 14))
                                            .foregroundColor(AppColors.textSecondary)
                                        
                                        HStack(spacing: 6) {
                                            Image(systemName: seasonIcon(for: fragrance.season))
                                                .foregroundColor(AppColors.primaryYellow)
                                            Text(fragrance.season.displayName)
                                                .font(.bellGothicBold(size: 16))
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Style")
                                            .font(.bellGothicRegular(size: 14))
                                            .foregroundColor(AppColors.textSecondary)
                                        
                                        Text(fragrance.style)
                                            .font(.bellGothicBold(size: 16))
                                            .foregroundColor(AppColors.textAccent)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(AppColors.primaryYellow.opacity(0.2))
                                            )
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Rating")
                                        .font(.bellGothicRegular(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    HStack(spacing: 4) {
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= fragrance.rating ? "star.fill" : "star")
                                                .foregroundColor(AppColors.primaryYellow)
                                                .font(.title3)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("(\(fragrance.rating)/5)")
                                            .font(.bellGothicRegular(size: 16))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description")
                                        .font(.bellGothicRegular(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    Text(fragrance.description.isEmpty ? "No description available" : fragrance.description)
                                        .font(.bellGothicRegular(size: 16))
                                        .foregroundColor(fragrance.description.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                                        .lineLimit(nil)
                                }
                                
                                HStack {
                                    Text("Added:")
                                        .font(.bellGothicRegular(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text(DateFormatter.longDate.string(from: fragrance.dateAdded))
                                        .font(.bellGothicRegular(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardGradient)
                                    .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                            )
                            
                            HStack {
                                Text("Add to Favorites")
                                    .font(.bellGothicBold(size: 18))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    toggleFavorite(for: fragrance)
                                }) {
                                    Image(systemName: fragrance.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(fragrance.isFavorite ? AppColors.primaryYellow : AppColors.textSecondary)
                                        .font(.title2)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardGradient)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Edit")
                                            .font(.bellGothicBold(size: 18))
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryYellow)
                                    )
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                            .font(.bellGothicBold(size: 18))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.buttonDanger)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
                .navigationTitle(fragrance.name)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingEditView) {
                    if let fragranceToEdit = viewModel.getFragrance(by: fragranceId) {
                        EditFragranceView(fragrance: fragranceToEdit) { updatedFragrance in
                            viewModel.updateFragrance(updatedFragrance)
                        }
                        .environmentObject(viewModel)
                    }
                }
                .alert("Delete Fragrance", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteFragrance()
                    }
                } message: {
                    Text("Are you sure you want to delete this fragrance? This action cannot be undone.")
                }
            } else {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Fragrance not found")
                            .font(.bellGothicBold(size: 20))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func toggleFavorite(for fragrance: Fragrance) {
        viewModel.toggleFavorite(for: fragrance)
    }
    
    private func deleteFragrance() {
        if let fragrance = currentFragrance {
            viewModel.deleteFragrance(fragrance)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func seasonIcon(for season: Season) -> String {
        switch season {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        case .allSeasons: return "circle"
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    let sampleFragrance = Fragrance(
        name: "Sample Fragrance",
        brand: "Sample Brand",
        season: .summer,
        style: "Evening",
        rating: 4,
        description: "A beautiful summer fragrance with floral notes."
    )
    let viewModel = FragranceViewModel()
    viewModel.addFragrance(sampleFragrance)
    
    return NavigationView {
        FragranceDetailView(fragranceId: sampleFragrance.id)
            .environmentObject(viewModel)
    }
}
