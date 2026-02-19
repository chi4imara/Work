import SwiftUI

struct GadgetSavedView: View {
    let gadget: Gadget
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var isAnimating = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.lightBlue.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .scaleEffect(isAnimating ? 1.2 : 1.0)
                                .opacity(isAnimating ? 0.5 : 1.0)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color.theme.lightBlue)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                        }
                        
                        Text("Gadget Saved")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 8) {
                            Text(gadget.name)
                                .font(.playfairDisplay(size: 22, weight: .bold))
                                .foregroundColor(Color.theme.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text(gadget.category)
                                .font(.playfairDisplay(size: 14, weight: .medium))
                                .foregroundColor(Color.theme.lightBlue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.theme.lightBlue.opacity(0.2))
                                )
                        }
                        .padding(.bottom, 20)
                        
                        VStack(spacing: 16) {
                            DetailRow(title: "Purchase Date", value: dateFormatter.string(from: gadget.purchaseDate))
                            DetailRow(title: "Price", value: gadget.price)
                            DetailRow(title: "Condition", value: gadget.condition)
                            DetailRow(title: "Service Life", value: "\(gadget.serviceLife) years")
                            
                            if !gadget.comment.isEmpty {
                                DetailRow(title: "Comment", value: gadget.comment)
                            } else {
                                DetailRow(title: "Comment", value: "Comment not added.")
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.theme.cardBackground)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                            }
                    )
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        gadgetViewModel.navigateToRoot()
                    }) {
                        Text("Done")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.theme.accentGradient)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.bottom, 120)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.playfairDisplay(size: 14))
                .foregroundColor(Color.theme.primaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    GadgetSavedView(
        gadget: Gadget(
            name: "iPhone 13",
            category: "Phone",
            purchaseDate: Date(),
            price: "$899",
            condition: "Excellent",
            serviceLife: "2",
            comment: "Used for work"
        ),
        gadgetViewModel: GadgetViewModel()
    )
}
