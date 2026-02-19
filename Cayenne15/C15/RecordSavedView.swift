import SwiftUI

struct RecordSavedView: View {
    let record: CarRecord
    let onDone: () -> Void
    
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(ColorManager.green.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        if showCheckmark {
                            Image(systemName: "checkmark")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(ColorManager.green)
                                .scaleEffect(showCheckmark ? 1.0 : 0.5)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCheckmark)
                        }
                    }
                    
                    Text("Record Saved")
                        .font(FontManager.playfairBold(size: 28))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                VStack(spacing: 20) {
                    RecordDetailRow(
                        icon: record.type.icon,
                        title: "Operation Type",
                        value: record.type.rawValue
                    )
                    
                    RecordDetailRow(
                        icon: "calendar",
                        title: "Date",
                        value: record.formattedDate
                    )
                    
                    RecordDetailRow(
                        icon: "speedometer",
                        title: "Mileage",
                        value: record.mileage
                    )
                    
                    RecordDetailRow(
                        icon: "text.bubble",
                        title: "Comment",
                        value: record.displayComment
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorManager.darkBlue.opacity(0.4))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                        }
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: onDone) {
                    Text("Done")
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(ColorManager.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(ColorManager.accentGradient)
                        .cornerRadius(28)
                        .padding(.horizontal, 20)
                }
                
                Spacer().frame(height: 50)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCheckmark = true
            }
        }
    }
}

struct RecordDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(ColorManager.lightBlue)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(FontManager.playfairMedium(size: 14))
                    .foregroundColor(ColorManager.secondaryText)
                
                Text(value)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    RecordSavedView(
        record: CarRecord(
            type: .wash,
            date: Date(),
            mileage: "124530",
            comment: "Full wash with interior cleaning"
        )
    ) {}
}
