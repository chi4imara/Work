import SwiftUI

struct OutfitDetailView: View {
    let outfitId: UUID
    @ObservedObject var viewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var outfit: OutfitEntry? {
        viewModel.outfits.first(where: { $0.id == outfitId })
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                ZStack {
                    ColorManager.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            headerSection(outfit: outfit)
                            
                            descriptionSection(outfit: outfit)
                            
                            metricsSection(outfit: outfit)
                            
                            if !outfit.notes.isEmpty {
                                notesSection(outfit: outfit)
                            }
                            
                            if !outfit.tags.isEmpty {
                                tagsSection(outfit: outfit)
                            }
                            
                            actionButtons(outfit: outfit)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
                .navigationTitle("Outfit Details")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingEditView) {
                    EditOutfitView(outfit: outfit, viewModel: viewModel)
                }
                .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteOutfit(outfit)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this outfit entry? This action cannot be undone.")
                }
            } else {
                ZStack {
                    ColorManager.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("Outfit Not Found")
                            .font(.playfairDisplay(24, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("The outfit you're looking for doesn't exist or has been deleted.")
                            .font(.playfairDisplay(16))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(ColorManager.purpleGradient)
                        .cornerRadius(25)
                    }
                }
                .navigationTitle("Outfit Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func headerSection(outfit: OutfitEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outfit from \(outfit.dateString)")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: outfit.mood.icon)
                        .foregroundColor(outfit.mood.color)
                    Text(outfit.mood.rawValue)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(outfit.mood.color)
                }
                
                Spacer()
                
                Text("Added \(timeAgoString(for: outfit))")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding(.bottom, 8)
    }
    
    private func descriptionSection(outfit: OutfitEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Text(outfit.description)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
                .lineSpacing(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
        }
    }
    
    private func metricsSection(outfit: OutfitEntry) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Metrics")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Comfort Level")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        HStack {
                            Text("\(outfit.comfort)/10")
                                .font(.playfairDisplay(20, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(1...10, id: \.self) { index in
                                    Rectangle()
                                        .fill(index <= outfit.comfort ? ColorManager.accentYellow : ColorManager.neutralGray.opacity(0.3))
                                        .frame(width: 20, height: 6)
                                        .cornerRadius(3)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Others' Reaction")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        HStack {
                            Circle()
                                .fill(outfit.reaction.color)
                                .frame(width: 16, height: 16)
                            
                            Text(outfit.reaction.rawValue)
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(outfit.reaction.color)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
            }
        }
    }
    
    private func notesSection(outfit: OutfitEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Text(outfit.notes)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
                .lineSpacing(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
        }
    }
    
    private func tagsSection(outfit: OutfitEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100), spacing: 8)
            ], spacing: 8) {
                ForEach(outfit.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(ColorManager.accentYellow.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private func actionButtons(outfit: OutfitEntry) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    Text("Edit Outfit")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(ColorManager.purpleGradient)
                .cornerRadius(12)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text("Delete Outfit")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(ColorManager.warningRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(ColorManager.warningRed.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    private func timeAgoString(for outfit: OutfitEntry) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: outfit.date, relativeTo: Date())
    }
}

#Preview {
    let viewModel = OutfitViewModel()
    let sampleOutfit = OutfitEntry(
        date: Date(),
        description: "Black dress with blazer, ankle boots, crossbody bag",
        comfort: 8,
        mood: .happy,
        reaction: .positive,
        notes: "Perfect for the office meeting. Got several compliments!",
        tags: ["office", "black", "comfortable", "professional"]
    )
    viewModel.addOutfit(sampleOutfit)
    
    return NavigationView {
        OutfitDetailView(
            outfitId: sampleOutfit.id,
            viewModel: viewModel
        )
    }
}

