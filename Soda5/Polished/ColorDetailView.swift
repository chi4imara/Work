import SwiftUI

struct ColorDetailView: View {
    let colorStatistic: ColorStatistic
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if colorStatistic.manicures.isEmpty {
                    emptyStateView
                } else {
                    manicuresList
                }
            }
        }
        .navigationTitle("Manicures with color: \(colorStatistic.color)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(AppColors.purpleGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(colorStatistic.color.prefix(2)).uppercased())
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.contrastText)
                )
            
            VStack(spacing: 8) {
                Text(colorStatistic.color)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(colorStatistic.count) time\(colorStatistic.count == 1 ? "" : "s") used")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("This color has not been used yet")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add a record with it to see the history.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var manicuresList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(colorStatistic.manicures) { manicure in
                    NavigationLink(destination: ManicureDetailView(manicureId: manicure.id)) {
                        ColorManicureCardView(manicure: manicure, dateFormatter: dateFormatter)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct ColorManicureCardView: View {
    let manicure: Manicure
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateFormatter.string(from: manicure.date))
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    if !manicure.salon.isEmpty {
                        HStack {
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundColor(AppColors.blueText)
                            
                            Text(manicure.salon)
                                .font(.playfairDisplay(14))
                                .foregroundColor(AppColors.blueText)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !manicure.note.isEmpty {
                Text(manicure.note)
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
