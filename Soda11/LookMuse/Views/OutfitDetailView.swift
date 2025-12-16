import SwiftUI

struct OutfitDetailView: View {
    let outfitID: UUID
    @ObservedObject var viewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var outfit: OutfitModel? {
        viewModel.outfits.first { $0.id == outfitID }
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            outfitDetailsView(outfit: outfit)
                            
                            actionButtonsView(outfit: outfit)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditOutfitView(outfitID: outfitID, viewModel: viewModel)
                }
                .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteOutfit(outfit)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this outfit? This action cannot be undone.")
                }
            } else {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Outfit not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.buttonText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.buttonBackground)
                        )
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.theme.secondaryButtonBackground)
                    )
            }
            
            Spacer()
            
            Text("Outfit Details")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Menu {
                Button(action: {
                    showingEditView = true
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: {
                    showingDeleteAlert = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.theme.secondaryButtonBackground)
                    )
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private func outfitDetailsView(outfit: OutfitModel) -> some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text(outfit.dateString)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Season")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    HStack(spacing: 6) {
                        Image(systemName: outfit.season.icon)
                            .font(.system(size: 16))
                            .foregroundColor(outfit.season.color)
                        
                        Text(outfit.season.rawValue)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.darkCardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
            
            DetailCard(
                title: "Outfit Description",
                content: outfit.description,
                icon: "tshirt"
            )
            
            HStack(spacing: 16) {
                DetailCard(
                    title: "Location",
                    content: outfit.location.isEmpty ? "Not specified" : outfit.location,
                    icon: "location",
                    isCompact: true
                )
                
                DetailCard(
                    title: "Weather",
                    content: outfit.weather.isEmpty ? "Not specified" : outfit.weather,
                    icon: "cloud.sun",
                    isCompact: true
                )
            }
            
            if !outfit.comment.isEmpty {
                DetailCard(
                    title: "Comment",
                    content: outfit.comment,
                    icon: "note.text"
                )
            } else {
                DetailCard(
                    title: "Comment",
                    content: "No comments added",
                    icon: "note.text",
                    isEmpty: true
                )
            }
        }
    }
    
    private func actionButtonsView(outfit: OutfitModel) -> some View {
        HStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(Color.theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(Color.theme.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.errorColor.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.theme.errorColor.opacity(0.5), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.top, 20)
    }
}

struct DetailCard: View {
    let title: String
    let content: String
    let icon: String
    var isCompact: Bool = false
    var isEmpty: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.theme.primaryYellow)
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(.ubuntu(isCompact ? 14 : 16, weight: .regular))
                .foregroundColor(isEmpty ? Color.theme.secondaryText.opacity(0.7) : Color.theme.primaryText)
                .multilineTextAlignment(.leading)
                .lineLimit(isCompact ? 2 : nil)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.darkCardBackground)
                .shadow(color: Color.theme.lightShadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    let viewModel = OutfitViewModel()
    let sampleOutfit = OutfitModel(
        date: Date(),
        description: "Denim jacket, white t-shirt, sneakers",
        location: "Park walk",
        weather: "+16°C, sunny",
        comment: "Comfortable, but sneakers were a bit tight."
    )
    viewModel.addOutfit(sampleOutfit)
    
    return OutfitDetailView(outfitID: sampleOutfit.id, viewModel: viewModel)
}
