import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: SeasonItemViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Text("Seasonal Items")
                        .font(FontManager.bauhausBold(28))
                        .foregroundColor(AppColors.primaryText)
                    
                    if viewModel.totalItemsCount > 0 {
                        Text("Total items: \(viewModel.totalItemsCount)")
                            .font(FontManager.bauhausLight(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                if viewModel.items.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "tshirt")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                        
                        VStack(spacing: 10) {
                            Text("No seasonal items yet")
                                .font(FontManager.bauhausMedium(20))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Add items and mark which season you wear them")
                                .font(FontManager.bauhausLight(16))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: {
                            showingAddItem = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add First Item")
                            }
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.contrastText)
                            .padding()
                            .background(AppColors.primaryBlue)
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.items) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                    ItemCardView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
            
            if !viewModel.items.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddItem = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.contrastText)
                                .frame(width: 56, height: 56)
                                .background(AppColors.primaryBlue)
                                .clipShape(Circle())
                                .shadow(color: AppColors.primaryBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddItem) {
            AddItemView(viewModel: viewModel)
        }
    }
}
