import SwiftUI

struct FragranceDetailView: View {
    let fragranceId: UUID
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var fragrance: Fragrance? {
        fragranceViewModel.fragrances.first(where: { $0.id == fragranceId })
    }
    
    var body: some View {
        Group {
            if let fragrance = fragrance {
                contentView(fragrance: fragrance)
            } else {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        VStack {
                            Text("Fragrance not found")
                                .font(.lumierepolis(18))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.primaryWhite)
                    )
                }
            }
        }
    }
    
    private func contentView(fragrance: Fragrance) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(fragrance.name)
                                .font(.lumierepolis(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack {
                                FormatBadge(format: fragrance.format)
                                SeasonBadge(season: fragrance.season)
                                Spacer()
                            }
                        }
                        
                        if !fragrance.notes.isEmpty {
                            DetailSection(title: "Notes") {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(fragrance.notes, id: \.self) { note in
                                        HStack {
                                            Circle()
                                                .fill(AppColors.accentPink)
                                                .frame(width: 6, height: 6)
                                            
                                            Text(note)
                                                .font(.lumierepolis(16))
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        
                        if !fragrance.description.isEmpty {
                            DetailSection(title: "Personal Notes") {
                                Text(fragrance.description)
                                    .font(.lumierepolis(16))
                                    .foregroundColor(AppColors.primaryText)
                                    .lineSpacing(4)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Fragrance")
                                }
                                .font(.lumierepolis(16, weight: .bold))
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.buttonPrimary)
                                .cornerRadius(25)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Fragrance")
                                }
                                .font(.lumierepolis(16, weight: .bold))
                                .foregroundColor(AppColors.accentPink)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.buttonSecondary)
                                .cornerRadius(25)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryWhite)
            )
        }
        .sheet(isPresented: $showingEditView) {
            EditFragranceView(
                fragrance: fragrance,
                fragranceViewModel: fragranceViewModel
            )
        }
        .alert("Delete Fragrance", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let currentFragrance = self.fragrance {
                    fragranceViewModel.deleteFragrance(currentFragrance)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this fragrance? This action cannot be undone.")
        }
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(16)
        }
    }
}

struct FormatBadge: View {
    let format: FragranceFormat
    
    var body: some View {
        Text(format.displayName)
            .font(.lumierepolis(12, weight: .bold))
            .foregroundColor(AppColors.primaryWhite)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.buttonPrimary)
            .cornerRadius(16)
    }
}

struct SeasonBadge: View {
    let season: Season
    
    var body: some View {
        Text(season.displayName)
            .font(.lumierepolis(12, weight: .bold))
            .foregroundColor(AppColors.primaryWhite)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.accentGreen)
            .cornerRadius(16)
    }
}

#Preview {
    let viewModel = FragranceViewModel()
    let sampleFragrance = Fragrance(
        name: "Sample Fragrance",
        notes: ["Rose", "Vanilla", "Sandalwood"],
        season: .spring,
        format: .day,
        description: "A beautiful floral fragrance perfect for spring days."
    )
    viewModel.addFragrance(sampleFragrance)
    
    return FragranceDetailView(
        fragranceId: sampleFragrance.id,
        fragranceViewModel: viewModel
    )
}
