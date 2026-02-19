import SwiftUI

struct ProcedureSavedView: View {
    let procedure: Procedure
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.green)
                }
                
                Text("Procedure Saved")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Date:")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Spacer()
                        
                        Text(procedure.dateString)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.white)
                    }
                    
                    Divider()
                        .background(AppColors.white.opacity(0.3))
                    
                    HStack {
                        Text("Type:")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Spacer()
                        
                        Text(procedure.type.displayName)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.white)
                    }
                    
                    Divider()
                        .background(AppColors.white.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Products Used:")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text(procedure.products)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.white)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Divider()
                        .background(AppColors.white.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment:")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text(procedure.comment.isEmpty ? "No comment added." : procedure.comment)
                            .font(.ubuntu(16))
                            .foregroundColor(procedure.comment.isEmpty ? AppColors.white.opacity(0.6) : AppColors.white)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: onDone) {
                    Text("Done")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [AppColors.orange, AppColors.orange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}
