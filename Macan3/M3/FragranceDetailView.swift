import SwiftUI

struct FragranceDetailView: View {
    let fragrance: Fragrance
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    detailsSection
                    notesSection
                    if !fragrance.comment.isEmpty {
                        commentSection
                    }
                    actionButtons
                }
                .padding(20)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("Fragrance Details")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditView) {
            EditFragranceView(fragrance: fragrance, viewModel: viewModel)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Fragrance"),
                message: Text("Are you sure you want to delete this fragrance? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteFragrance()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text(fragrance.name)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text(fragrance.brand)
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            HStack(spacing: 16) {
                HStack {
                    Image(systemName: fragrance.type == .daytime ? "sun.max.fill" : "moon.fill")
                    Text(fragrance.type.displayName)
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.accentYellow)
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: fragrance.season.icon)
                    Text(fragrance.season.displayName)
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.cardBackground)
                .cornerRadius(8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            if !fragrance.atmosphere.isEmpty {
                DetailRow(
                    title: "Atmosphere",
                    value: fragrance.atmosphere,
                    icon: "sparkles"
                )
            }
            
            DetailRow(
                title: "Added",
                value: DateFormatter.displayFormatter.string(from: fragrance.dateAdded),
                icon: "calendar"
            )
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Main Notes")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            if fragrance.mainNotes.isEmpty {
                Text("No notes added")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.tertiaryText)
                    .italic()
            } else {
                Text(fragrance.mainNotes)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(fragrance.comment)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.error, lineWidth: 1)
                )
            }
        }
    }
    
    private func deleteFragrance() {
        viewModel.deleteFragrance(fragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.tertiaryText)
                
                Text(value)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NavigationView {
        FragranceDetailView(
            fragrance: Fragrance(
                name: "Replica Lazy Sunday Morning",
                brand: "Maison Margiela",
                type: .daytime,
                season: .spring,
                mainNotes: "iris, white musk, pear",
                atmosphere: "fresh, clean, relaxing",
                comment: "Smells like morning laundry and sunlight."
            ),
            viewModel: FragranceViewModel()
        )
    }
}
