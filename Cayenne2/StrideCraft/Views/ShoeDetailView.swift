import SwiftUI

struct ShoeDetailView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let shoe: Shoe
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "shoe.2.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.lightBlue)
                        
                        Text(shoe.model)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        detailCard(title: "Category", value: shoe.category.displayName, icon: "tag.fill")
                        detailCard(title: "Condition", value: shoe.condition.displayName, icon: "checkmark.seal.fill")
                        detailCard(title: "Season", value: shoe.season.displayName, icon: "thermometer.sun.fill")
                        detailCard(title: "Purchase Date", value: formattedDate(shoe.purchaseDate), icon: "calendar.badge.plus")
                        
                        if !shoe.comment.isEmpty {
                            commentCard()
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorTheme.primaryButton)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorTheme.destructiveButton)
                            .cornerRadius(25)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryButton)
            }
        )
        .sheet(isPresented: $showingEditView) {
            EditShoeView(shoe: shoe)
                .environmentObject(viewModel)
        }
        .alert("Delete Pair?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteShoe(shoe)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func detailCard(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
    
    private func commentCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.quote")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.lightBlue)
                
                Text("Comment")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Spacer()
            }
            
            Text(shoe.comment)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(ColorTheme.primaryText)
                .lineSpacing(4)
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        ShoeDetailView(shoe: Shoe(
            model: "Nike Air Force 1",
            category: .sneakers,
            condition: .excellent,
            season: .allSeason,
            purchaseDate: Date(),
            comment: "Great for everyday wear"
        ))
        .environmentObject(ShoesViewModel())
    }
}
