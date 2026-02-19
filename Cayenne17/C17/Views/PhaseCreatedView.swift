import SwiftUI

struct PhaseCreatedView: View {
    let phase: Phase
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(AppColors.green)
                }
                
                Text("Phase Created")
                    .font(.playfairDisplay(.bold, size: 32))
                    .foregroundColor(AppColors.white)
                
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Phase Name")
                            .font(.playfairDisplay(.medium, size: 16))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text(phase.name.rawValue)
                            .font(.playfairDisplay(.regular, size: 18))
                            .foregroundColor(AppColors.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .background(AppColors.white.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Start Date")
                            .font(.playfairDisplay(.medium, size: 16))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text(phase.startDate, style: .date)
                            .font(.playfairDisplay(.regular, size: 18))
                            .foregroundColor(AppColors.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .background(AppColors.white.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Comment")
                            .font(.playfairDisplay(.medium, size: 16))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text(phase.comment.isEmpty ? "Comment not added." : phase.comment)
                            .font(.playfairDisplay(.regular, size: 18))
                            .foregroundColor(AppColors.white)
                            .opacity(phase.comment.isEmpty ? 0.7 : 1.0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: onDone) {
                    Text("Done")
                        .font(.playfairDisplay(.semiBold, size: 18))
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.lightBlue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    PhaseCreatedView(
        phase: Phase(name: .mass, startDate: Date(), comment: "Test comment")
    ) {
        print("Done tapped")
    }
}
