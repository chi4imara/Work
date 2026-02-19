import SwiftUI

struct ScenarioBagsView: View {
    let scenario: BagScenario
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var scenarioBags: [Bag] {
        viewModel.bagsByScenario(scenario)
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.theme.textWhite)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text(scenario.displayName)
                            .font(.bellGothicBold(size: 20))
                            .foregroundColor(Color.theme.textWhite)
                        
                        Text("\(scenarioBags.count) bag\(scenarioBags.count == 1 ? "" : "s")")
                            .font(.bellGothicRegular(size: 14))
                            .foregroundColor(Color.theme.textGray)
                    }
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 18, height: 18)
                }
                .padding(.horizontal)
                .padding(.top)
                
                if scenarioBags.isEmpty {
                    EmptyScenarioBagsView(scenario: scenario)
                } else {
                    ScenarioBagsList(bags: scenarioBags, viewModel: viewModel)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct EmptyScenarioBagsView: View {
    let scenario: BagScenario
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: scenario.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textGray)
            
            VStack(spacing: 15) {
                Text("No bags for this scenario")
                    .font(.bellGothicBold(size: 24))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("Add bags with \(scenario.displayName.lowercased()) scenario to see them here")
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct ScenarioBagsList: View {
    let bags: [Bag]
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id, viewModel: viewModel)) {
                        BagCardView(bag: bag)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let viewModel = BagViewModel()
    return ScenarioBagsView(scenario: .day, viewModel: viewModel)
}
