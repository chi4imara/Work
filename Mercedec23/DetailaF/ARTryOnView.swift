import SwiftUI

struct ARTryOnView: View {
    let accessoryId: UUID
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @EnvironmentObject private var progressViewModel: ProgressViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isRecording = false
    @State private var showingRating = false
    @State private var rating = 0
    @State private var notes = ""
    
    private var accessory: Accessory? {
        accessoryViewModel.accessory(byId: accessoryId)
    }
    
    var body: some View {
        Group {
            if let accessory = accessory {
                NavigationView {
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.black.opacity(0.8), .gray.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .ignoresSafeArea()
                            .overlay(
                                VStack {
                                    Text("AR Camera View")
                                        .font(.playfairDisplay(24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Virtual try-on simulation")
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Image(systemName: accessory.category.icon)
                                            .font(.system(size: 80))
                                            .foregroundColor(AppColors.primaryYellow)
                                        
                                        Text(accessory.name)
                                            .font(.playfairDisplay(18, weight: .semibold))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(20)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(16)
                                    
                                    Spacer()
                                }
                            )
                        
                        VStack {
                            Spacer()
                            controlsSection
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(.white)
                            .font(.playfairDisplay(16, weight: .medium))
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                showingRating = true
                            }
                            .foregroundColor(AppColors.primaryYellow)
                            .font(.playfairDisplay(16, weight: .semibold))
                        }
                    }
                    .sheet(isPresented: $showingRating) {
                        RatingView(accessory: accessory, rating: $rating, notes: $notes) {
                            progressViewModel.addTryOnSession(accessory, rating: rating, notes: notes.isEmpty ? nil : notes)
                            dismiss()
                        }
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Text("Accessory not found")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    Button("Close") { dismiss() }
                        .foregroundColor(AppColors.primaryYellow)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AnimatedBackground())
            }
        }
    }
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                Button(action: { isRecording.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .fill(isRecording ? .red : AppColors.primaryYellow)
                            .frame(width: 60, height: 60)
                            .scaleEffect(isRecording ? 0.8 : 1.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isRecording)
                    }
                }
                
                Button(action: {}) {
                    Image(systemName: "camera.rotate")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                }
                
                Button(action: {}) {
                    Image(systemName: "flashlight.on.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AccessoryStyle.allCases, id: \.self) { style in
                        Button(action: {}) {
                            Text(style.rawValue)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 40)
    }
}

struct RatingView: View {
    let accessory: Accessory
    @Binding var rating: Int
    @Binding var notes: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Rate Your Try-On")
                            .font(.playfairDisplay(24, weight: .bold))
                            .foregroundColor(AppColors.textBlue)
                        
                        Text(accessory.name)
                            .font(.playfairDisplay(18, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: { rating = star }) {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.system(size: 32))
                                    .foregroundColor(star <= rating ? AppColors.primaryYellow : AppColors.lightGray)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(AppColors.textBlue)
                        
                        TextField("How did it look? Any styling tips?", text: $notes, axis: .vertical)
                            .font(.playfairDisplay(14, weight: .medium))
                            .padding(12)
                            .background(AppColors.backgroundWhite)
                            .cornerRadius(12)
                            .lineLimit(3...6)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onSave()
                        dismiss()
                    }) {
                        Text("Save Try-On")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonGradient)
                            .cornerRadius(AppConstants.cornerRadius)
                    }
                    .disabled(rating == 0)
                    .opacity(rating == 0 ? 0.6 : 1.0)
                }
                .padding(AppConstants.cardPadding)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.darkGray)
                    .font(.playfairDisplay(16, weight: .medium))
                }
            }
        }
    }
}

#Preview {
    ARTryOnView(accessoryId: UUID())
        .environmentObject(AccessoryViewModel())
        .environmentObject(ProgressViewModel())
}
