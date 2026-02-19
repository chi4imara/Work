import SwiftUI

struct FragranceDetailView: View {
    let fragranceId: UUID
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var fragrance: Fragrance? {
        viewModel.getFragrance(by: fragranceId)
    }
    
    var body: some View {
        Group {
            if let fragrance = fragrance {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                headerView(fragrance: fragrance)
                                
                                if fragrance.hasNotes {
                                    DetailSectionView(
                                        title: "Notes",
                                        content: fragrance.notes,
                                        icon: "leaf"
                                    )
                                }
                                
                                if let season = fragrance.season {
                                    DetailSectionView(
                                        title: "Season",
                                        content: season.displayName,
                                        icon: "calendar"
                                    )
                                }
                                
                                if fragrance.hasOccasions {
                                    DetailSectionView(
                                        title: "Occasions",
                                        content: fragrance.occasions,
                                        icon: "clock"
                                    )
                                }
                                
                                if fragrance.hasPersonalNotes {
                                    DetailSectionView(
                                        title: "Personal Notes",
                                        content: fragrance.personalNotes,
                                        icon: "note.text"
                                    )
                                }
                                
                                actionButtons(fragrance: fragrance)
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(fragrance.name)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.appTextGray)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditFragranceView(fragrance: fragrance, viewModel: viewModel)
                }
                .alert("Delete Fragrance", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteFragrance(fragrance)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete this fragrance? This action cannot be undone.")
                }
            } else {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            Text("Fragrance not found")
                                .font(.bauhausMedium(20))
                                .foregroundColor(.appPrimaryBlue)
                            
                            Button("Close") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.bauhausMedium(16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(AppColors.buttonGradient)
                            )
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.appTextGray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func headerView(fragrance: Fragrance) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(fragrance.name)
                        .font(.bauhausBold(24))
                        .foregroundColor(.appPrimaryBlue)
                        .lineLimit(nil)
                    
                    Text("Added \(fragrance.dateCreated.formatted(date: .abbreviated, time: .omitted))")
                        .font(.bauhausLight(14))
                        .foregroundColor(.appTextGray)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(fragrance)
                }) {
                    Image(systemName: fragrance.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(fragrance.isFavorite ? .appAccentPink : .appTextGray)
                        .scaleEffect(fragrance.isFavorite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3), value: fragrance.isFavorite)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func actionButtons(fragrance: Fragrance) -> some View {
        VStack(spacing: 15) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                        .font(.bauhausMedium(16))
                }
                .foregroundColor(.appPrimaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.appPrimaryBlue.opacity(0.2), radius: 8, x: 0, y: 4)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                        .font(.bauhausMedium(16))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.appPrimaryYellow)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.bauhausMedium(18))
                    .foregroundColor(.appPrimaryBlue)
            }
            
            Text(content)
                .font(.bauhausLight(16))
                .foregroundColor(.appTextGray)
                .lineLimit(nil)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    FragranceDetailView(
        fragranceId: Fragrance.sampleData[0].id,
        viewModel: FragranceViewModel()
    )
}
