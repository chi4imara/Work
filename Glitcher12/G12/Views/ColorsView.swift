import SwiftUI

struct ColorsView: View {
    @ObservedObject var viewModel: ManicureViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Colors")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.colors.isEmpty {
                    EmptyStateView(
                        title: "No colors yet",
                        subtitle: "Colors will appear after adding records",
                        systemImage: "paintpalette"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.colors) { color in
                                NavigationLink(destination: ColorManicuresView(colorName: color.name, viewModel: viewModel)) {
                                    ColorRow(color: color)
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

struct ColorRow: View {
    let color: ManicureColor
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(color.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                Text(color.countString)
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

struct ColorManicuresView: View {
    let colorName: String
    @ObservedObject var viewModel: ManicureViewModel
    
    var manicures: [Manicure] {
        viewModel.manicuresForColor(colorName)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if manicures.isEmpty {
                EmptyStateView(
                    title: "No manicures yet",
                    subtitle: "No manicures with this color yet",
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
        .navigationTitle(colorName)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
}

struct ManicureListCard: View {
    let manicureId: UUID
    @ObservedObject var viewModel: ManicureViewModel
    
    private var manicure: Manicure? {
        viewModel.manicures.first { $0.id == manicureId }
    }
    
    var body: some View {
        Group {
            if let manicure = manicure {
                cardContent(manicure: manicure)
            }
        }
    }
    
    private func cardContent(manicure: Manicure) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(manicure.designName)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorManager.mediumGray)
            }
            
            HStack {
                Label(manicure.master.name, systemImage: "person.fill")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.yellow)
                
                Spacer()
                
                Text(manicure.dateString)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
            
            if !manicure.notes.isEmpty {
                Text(manicure.notes)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(ColorManager.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorManager.cardBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

#Preview {
    ColorsView(viewModel: ManicureViewModel())
}
