import SwiftUI

struct ProcedureRowView: View {
    let procedure: Procedure
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: procedure.type.iconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.accent)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(procedure.type.displayName)
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text(procedure.shortFormattedDate)
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                    }
                    
                    if !procedure.product.isEmpty {
                        Text(procedure.product)
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    
                    if !procedure.note.isEmpty {
                        Text(procedure.note)
                            .font(FontManager.ubuntu(11, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                            .lineLimit(1)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.tertiaryText)
            }
            .padding(12)
            .background(ColorManager.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProcedureRowView(procedure: Procedure(type: .trim, date: Date(), product: "Beard Oil", note: "Test note")) {
        print("Tapped")
    }
    .padding()
    .background(ColorManager.backgroundGradient)
}
