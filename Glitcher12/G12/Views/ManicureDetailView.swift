import SwiftUI

struct ManicureDetailView: View {
    let manicureId: UUID
    @ObservedObject var viewModel: ManicureViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var manicure: Manicure? {
        viewModel.manicures.first { $0.id == manicureId }
    }
    
    var body: some View {
        Group {
            if let currentManicure = manicure {
                contentView(currentManicure: currentManicure)
            } else {
                Text("Manicure not found")
                    .foregroundColor(ColorManager.white)
            }
        }
    }
    
    private func contentView(currentManicure: Manicure) -> some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(currentManicure.designName)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorManager.white)
                            .multilineTextAlignment(.leading)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            InfoRow(title: "Colors", value: currentManicure.colorsString.isEmpty ? "No colors specified" : currentManicure.colorsString)
                            InfoRow(title: "Master", value: currentManicure.master.name)
                            InfoRow(title: "Date", value: currentManicure.dateString)
                            InfoRow(title: "Notes", value: currentManicure.notes.isEmpty ? "No notes" : currentManicure.notes)
                        }
                    }
                    .padding(20)
                    .background(ColorManager.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorManager.cardBorder, lineWidth: 1)
                    )
                    .cornerRadius(16)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.toggleFavorite(currentManicure)
                        }) {
                            HStack {
                                Image(systemName: currentManicure.isFavorite ? "heart.fill" : "heart")
                                    .font(.title3)
                                
                                Text(currentManicure.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(currentManicure.isFavorite ? AnyShapeStyle(ColorManager.yellow) : AnyShapeStyle(ColorManager.primaryButton))
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                
                                Text("Edit")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorManager.secondaryButton)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.title3)
                                
                                Text("Delete")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorManager.deleteButton)
                            .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle(String(currentManicure.designName.prefix(20)))
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditView) {
            EditManicureView(manicureId: manicureId, viewModel: viewModel)
        }
        .alert("Delete Manicure", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let manicure = manicure {
                    viewModel.deleteManicure(manicure)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this manicure? This action cannot be undone.")
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.yellow)
            
            Text(value)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(ColorManager.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        ManicureDetailView(
            manicureId: Manicure.sampleData[0].id,
            viewModel: ManicureViewModel()
        )
    }
}
