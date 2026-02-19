import SwiftUI

struct ScenariosView: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Scenarios")
                        .font(.bellGothicBold(size: 32))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                if viewModel.bags.isEmpty {
                    EmptyScenariosView()
                } else {
                    ScenariosList(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyScenariosView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.bullet")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textGray)
            
            VStack(spacing: 15) {
                Text("No scenarios yet")
                    .font(.bellGothicBold(size: 24))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("Scenarios will appear after adding bags")
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

struct ScenariosList: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(BagScenario.allCases) { scenario in
                    let bagCount = viewModel.bagCount(for: scenario)
                    
                    if bagCount > 0 {
                        NavigationLink(destination: ScenarioBagsView(scenario: scenario, viewModel: viewModel)) {
                            ScenarioCardView(scenario: scenario, bagCount: bagCount)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        ScenarioCardView(scenario: scenario, bagCount: bagCount)
                            .opacity(0.5)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 120)
        }
    }
}

struct ScenarioCardView: View {
    let scenario: BagScenario
    let bagCount: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: scenario.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color.theme.accentYellow)
                .frame(width: 50, height: 50)
                .background(Color.theme.accentYellow.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scenario.displayName)
                    .font(.bellGothicBold(size: 20))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("\(bagCount) bag\(bagCount == 1 ? "" : "s")")
                    .font(.bellGothicRegular(size: 14))
                    .foregroundColor(Color.theme.textGray)
            }
            
            Spacer()
            
            if bagCount > 0 {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.textGray)
            }
        }
        .padding()
        .background(Color.theme.cardGradient)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    ScenariosView(viewModel: BagViewModel())
}
