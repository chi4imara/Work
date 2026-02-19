import SwiftUI

struct BagDetailView: View {
    let bagId: UUID
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var bag: Bag? {
        viewModel.getBag(byId: bagId)
    }
    
    var body: some View {
        Group {
            if let bag = bag {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color.theme.textWhite)
                                }
                                
                                Spacer()
                                
                                Text(bag.name)
                                    .font(.bellGothicBold(size: 20))
                                    .foregroundColor(Color.theme.textWhite)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Color.clear
                                    .frame(width: 18, height: 18)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text(bag.name)
                                            .font(.bellGothicBold(size: 24))
                                            .foregroundColor(Color.theme.textWhite)
                                        
                                        Spacer()
                                        
                                        if bag.isFavorite {
                                            HStack(spacing: 4) {
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color.theme.errorRed)
                                                
                                                Text("Favorite")
                                                    .font(.bellGothicRegular(size: 14))
                                                    .foregroundColor(Color.theme.errorRed)
                                            }
                                        }
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: bag.scenario.icon)
                                            .font(.system(size: 18))
                                            .foregroundColor(Color.theme.accentYellow)
                                        
                                        Text(bag.scenario.displayName)
                                            .font(.bellGothicBold(size: 18))
                                            .foregroundColor(Color.theme.accentYellow)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Comment")
                                            .font(.bellGothicBold(size: 16))
                                            .foregroundColor(Color.theme.textWhite)
                                        
                                        if bag.comment.isEmpty {
                                            Text("No comment added")
                                                .font(.bellGothicRegular(size: 14))
                                                .foregroundColor(Color.theme.textGray)
                                                .italic()
                                        } else {
                                            Text(bag.comment)
                                                .font(.bellGothicRegular(size: 14))
                                                .foregroundColor(Color.theme.textGray)
                                                .lineSpacing(2)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.theme.cardGradient)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                
                                VStack(spacing: 12) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .semibold))
                                            
                                            Text("Edit")
                                                .font(.bellGothicBold(size: 16))
                                        }
                                        .foregroundColor(Color.theme.darkBlue)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.theme.buttonGradient)
                                        .cornerRadius(25)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .semibold))
                                            
                                            Text("Delete Bag")
                                                .font(.bellGothicBold(size: 16))
                                        }
                                        .foregroundColor(Color.theme.textWhite)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.theme.errorRed)
                                        .cornerRadius(25)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 50)
                        }
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showingEditView) {
                    EditBagView(bagId: bagId, viewModel: viewModel)
                }
                .alert("Delete Bag", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteBag(byId: bagId)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this bag? This action cannot be undone.")
                }
            } else {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Bag not found")
                            .font(.bellGothicBold(size: 20))
                            .foregroundColor(Color.theme.textWhite)
                    }
                }
            }
        }
    }
}

#Preview {
    let viewModel = BagViewModel()
    let sampleBag = Bag(
        name: "Black Leather Bag",
        scenario: .day,
        comment: "Perfect for daily use, fits laptop and essentials",
        isFavorite: true
    )
    viewModel.addBag(sampleBag)
    
    return BagDetailView(bagId: sampleBag.id, viewModel: viewModel)
}
