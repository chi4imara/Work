import SwiftUI

struct MastersView: View {
    @ObservedObject var viewModel: ManicureViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Masters")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.mastersWithCounts.isEmpty {
                    EmptyStateView(
                        title: "No masters yet",
                        subtitle: "Masters will appear after adding records",
                        systemImage: "person.2"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.mastersWithCounts, id: \.master.id) { masterData in
                                NavigationLink(destination: MasterManicuresView(master: masterData.master, viewModel: viewModel)) {
                                    MasterRow(master: masterData.master, count: masterData.count)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

struct MasterRow: View {
    let master: Master
    let count: Int
    
    var countString: String {
        "\(count) time\(count == 1 ? "" : "s")"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(master.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                Text(countString)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.yellow)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ColorManager.mediumGray)
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct MasterManicuresView: View {
    let master: Master
    @ObservedObject var viewModel: ManicureViewModel
    
    var manicures: [Manicure] {
        viewModel.manicuresForMaster(master)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if manicures.isEmpty {
                EmptyStateView(
                    title: "No manicures yet",
                    subtitle: "This master hasn't done your manicure yet",
                    systemImage: "paintbrush.pointed"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(manicures) { manicure in
                            NavigationLink(destination: ManicureDetailView(manicureId: manicure.id, viewModel: viewModel)) {
                                ManicureListCard(manicureId: manicure.id, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle(master.name)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MastersView(viewModel: ManicureViewModel())
}
