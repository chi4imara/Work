import SwiftUI

struct WomanDetailsView: View {
    let womanId: UUID
    @ObservedObject var viewModel: WomenViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var woman: Woman? {
        viewModel.getWoman(byId: womanId)
    }
    
    init(womanId: UUID, viewModel: WomenViewModel) {
        self.womanId = womanId
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let woman = woman {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 12) {
                                    Text(woman.name)
                                        .font(FontManager.ubuntu(28, weight: .bold))
                                        .foregroundColor(Color.theme.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(woman.profession)
                                        .font(FontManager.ubuntu(18, weight: .medium))
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                .padding(.top, 20)
                                
                                HStack {
                                    Text("Favorite Person")
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.toggleFavorite(for: woman)
                                    }) {
                                        Image(systemName: woman.isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 20))
                                            .foregroundColor(woman.isFavorite ? Color.theme.favoriteHeart : Color.theme.primaryText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.theme.cardBackground.opacity(0.2))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                
                                if woman.hasQuote {
                                    DetailSection(
                                        title: "Quote",
                                        content: woman.quote,
                                        icon: "quote.bubble.fill"
                                    )
                                } else {
                                    EmptySection(
                                        title: "Quote",
                                        message: "No quote added yet.",
                                        icon: "quote.bubble"
                                    )
                                }
                                
                                if woman.hasNote {
                                    DetailSection(
                                        title: "Personal Note",
                                        content: woman.personalNote,
                                        icon: "note.text"
                                    )
                                } else {
                                    EmptySection(
                                        title: "Personal Note",
                                        message: "No personal note added yet.",
                                        icon: "note.text"
                                    )
                                }
                                
                                VStack(spacing: 16) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                            Text("Edit Entry")
                                        }
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(Color.theme.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.theme.buttonPrimary)
                                        .cornerRadius(12)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete Entry")
                                        }
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.theme.buttonDestructive)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    .navigationTitle("Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(Color.theme.primaryText)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    AddWomanView(
                        viewModel: viewModel,
                        isPresented: $showingEditView,
                        existingWoman: woman
                    ) {
                        showingEditView = false
                    }
                }
                .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteWoman(woman)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete \(woman.name)? This action cannot be undone.")
                }
            } else {
                Text("Woman not found")
                    .foregroundColor(Color.theme.primaryText)
            }
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.theme.primaryYellow)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(FontManager.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(FontManager.ubuntu(15))
                .foregroundColor(Color.theme.primaryText)
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color.theme.cardBackground.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

struct EmptySection: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.theme.grayText)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(FontManager.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
            }
            
            Text(message)
                .font(FontManager.ubuntu(14))
                .foregroundColor(Color.theme.secondaryText)
                .italic()
        }
        .padding(20)
        .background(Color.theme.cardBackground.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let viewModel = WomenViewModel()
    let woman = Woman(
        name: "Coco Chanel",
        profession: "Designer",
        quote: "To be irreplaceable, one must always be different.",
        personalNote: "Her boldness and simplicity in style inspire me.",
        isFavorite: true
    )
    viewModel.addWoman(woman)
    return WomanDetailsView(
        womanId: woman.id,
        viewModel: viewModel
    )
}
