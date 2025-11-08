import SwiftUI

struct AddEditGiftView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @Environment(\.dismiss) private var dismiss
    
    let giftToEdit: GiftIdea?
    
    @State private var recipientName = ""
    @State private var giftDescription = ""
    @State private var selectedOccasion: GiftOccasion?
    @State private var selectedStatus: GiftStatus = .idea
    @State private var estimatedPrice = ""
    @State private var comment = ""
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    init(viewModel: GiftIdeaViewModel, giftToEdit: GiftIdea? = nil) {
        self.viewModel = viewModel
        self.giftToEdit = giftToEdit
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            FormField(
                                title: "Recipient Name *",
                                text: $recipientName,
                                placeholder: "Enter recipient name"
                            )
                            
                            FormField(
                                title: "Gift Idea *",
                                text: $giftDescription,
                                placeholder: "Enter gift idea"
                            )
                        
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Occasion")
                                    .font(.theme.headline)
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Menu {
                                    Button("None") {
                                        selectedOccasion = nil
                                    }
                                    ForEach(GiftOccasion.allCases, id: \.self) { occasion in
                                        Button(occasion.displayName) {
                                            selectedOccasion = occasion
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedOccasion?.displayName ?? "Select occasion")
                                            .foregroundColor(selectedOccasion == nil ? Color.theme.secondaryText : Color.theme.primaryText)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    .padding()
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.theme.headline)
                                    .foregroundColor(Color.theme.primaryText)
                                
                                HStack(spacing: 12) {
                                    ForEach(GiftStatus.allCases, id: \.self) { status in
                                        StatusButton(
                                            status: status,
                                            isSelected: selectedStatus == status
                                        ) {
                                            selectedStatus = status
                                        }
                                    }
                                }
                            }
                            
                            FormField(
                                title: "Estimated Price",
                                text: $estimatedPrice,
                                placeholder: "0.00",
                                keyboardType: .decimalPad
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.theme.headline)
                                    .foregroundColor(Color.theme.primaryText)
                                
                                TextField("Add a comment", text: $comment, axis: .vertical)
                                    .lineLimit(3...6)
                                    .padding()
                                    .background(Color.theme.cardBackground)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
                
                VStack {
                    Spacer()
                    Button(action: saveGift) {
                        Text(giftToEdit == nil ? "Save Gift Idea" : "Update Gift Idea")
                            .font(.theme.buttonLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.primaryBlue)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle(giftToEdit == nil ? "Add Gift Idea" : "Edit Gift Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
            .alert("Validation Error", isPresented: $showingValidationError) {
                Button("OK") { }
            } message: {
                Text(validationMessage)
            }
        }
        .onAppear {
            loadGiftData()
        }
    }
    
    private func loadGiftData() {
        if let gift = giftToEdit {
            recipientName = gift.recipientName
            giftDescription = gift.giftDescription
            selectedOccasion = gift.occasion
            selectedStatus = gift.status
            estimatedPrice = gift.estimatedPrice?.formatted() ?? ""
            comment = gift.comment
        }
    }
    
    private func saveGift() {
        guard !recipientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationError("Please enter recipient name")
            return
        }
        
        guard !giftDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationError("Please enter gift idea")
            return
        }
        
        var price: Double?
        if !estimatedPrice.isEmpty {
            price = Double(estimatedPrice)
            if price == nil {
                showValidationError("Please enter a valid price")
                return
            }
            if price! < 0 {
                showValidationError("Price cannot be negative")
                return
            }
        }
        
        if let existingGift = giftToEdit {
            var updatedGift = existingGift
            updatedGift.recipientName = recipientName.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedGift.giftDescription = giftDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedGift.occasion = selectedOccasion
            updatedGift.status = selectedStatus
            updatedGift.estimatedPrice = price
            updatedGift.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateGiftIdea(updatedGift)
        } else {
            let newGift = GiftIdea(
                recipientName: recipientName.trimmingCharacters(in: .whitespacesAndNewlines),
                giftDescription: giftDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                occasion: selectedOccasion,
                status: selectedStatus,
                estimatedPrice: price,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addGiftIdea(newGift)
        }
        
        dismiss()
    }
    
    private func showValidationError(_ message: String) {
        validationMessage = message
        showingValidationError = true
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.theme.headline)
                .foregroundColor(Color.theme.primaryText)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct StatusButton: View {
    let status: GiftStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: status.iconName)
                    .font(.title3)
                Text(status.displayName)
                    .font(.theme.caption)
            }
            .foregroundColor(isSelected ? .white : statusColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? statusColor : Color.theme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(statusColor, lineWidth: isSelected ? 0 : 1)
            )
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .idea:
            return Color.theme.ideaColor
        case .bought:
            return Color.theme.boughtColor
        case .gifted:
            return Color.theme.giftedColor
        }
    }
}

#Preview {
    AddEditGiftView(viewModel: GiftIdeaViewModel())
}
