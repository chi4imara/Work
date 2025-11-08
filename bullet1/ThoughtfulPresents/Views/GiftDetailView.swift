import SwiftUI

struct GiftDetailView: View {
    let giftId: UUID
    @ObservedObject var viewModel: GiftIdeaViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var giftToEdit: GiftIdea?
    @State private var showingDeleteAlert = false
    
    private var gift: GiftIdea? {
        viewModel.giftIdeas.first { $0.id == giftId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if let gift = gift {
                    ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(gift.recipientName)
                                    .font(.theme.largeTitle)
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Spacer()
                                
                                StatusBadge(status: gift.status)
                            }
                            
                            Text(gift.giftDescription)
                                .font(.theme.title2)
                                .foregroundColor(Color.theme.primaryText)
                        }
                        .padding(20)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Details")
                                .font(.theme.title3)
                                .foregroundColor(Color.theme.primaryText)
                            
                            if let occasion = gift.occasion {
                                DetailRow(
                                    icon: "calendar",
                                    title: "Occasion",
                                    value: occasion.displayName
                                )
                            }
                            
                            if let price = gift.estimatedPrice {
                                DetailRow(
                                    icon: "dollarsign.circle",
                                    title: "Estimated Price",
                                    value: String(format: "$%.2f", price)
                                )
                            }
                            
                            if !gift.comment.isEmpty {
                                DetailRow(
                                    icon: "text.bubble",
                                    title: "Comment",
                                    value: gift.comment
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Timeline")
                                .font(.theme.title3)
                                .foregroundColor(Color.theme.primaryText)
                            
                            DetailRow(
                                icon: "plus.circle",
                                title: "Date Added",
                                value: gift.dateAdded.formatted(date: .abbreviated, time: .shortened)
                            )
                            
                            DetailRow(
                                icon: "pencil.circle",
                                title: "Last Modified",
                                value: gift.dateModified.formatted(date: .abbreviated, time: .shortened)
                            )
                        }
                        .padding(20)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
                        
                        VStack(spacing: 12) {
                            Button(action: { giftToEdit = gift }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Gift Idea")
                                }
                                .font(.theme.buttonLarge)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.primaryBlue)
                                .cornerRadius(25)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Gift Idea")
                                }
                                .font(.theme.buttonLarge)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.errorRed)
                                .cornerRadius(25)
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                } else {
                    VStack(spacing: 24) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color.theme.errorRed.opacity(0.6))
                        
                        Text("Gift Not Found")
                            .font(.theme.title2)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("This gift may have been deleted")
                            .font(.theme.body)
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.theme.buttonMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.theme.primaryBlue)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Gift Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .sheet(item: $giftToEdit) { gift in
            AddEditGiftView(viewModel: viewModel, giftToEdit: gift)
        }
        .alert("Delete Gift Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let gift = gift {
                    viewModel.deleteGiftIdea(gift)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this gift idea? This action cannot be undone.")
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.theme.primaryBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.theme.headline)
                    .foregroundColor(Color.theme.primaryText)
                
                Text(value)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
        }
    }
}
