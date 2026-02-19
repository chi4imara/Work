import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let interactive: Bool
    let color: Color
    let size: CGFloat
    
    init(rating: Binding<Int>, interactive: Bool = true, color: Color = AppColors.primaryYellow, size: CGFloat = 20) {
        self._rating = rating
        self.interactive = interactive
        self.color = color
        self.size = size
    }
    
    init(rating: Int, interactive: Bool = false, color: Color = AppColors.primaryYellow, size: CGFloat = 20) {
        self._rating = .constant(rating)
        self.interactive = interactive
        self.color = color
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(star <= rating ? color : Color.gray.opacity(0.3))
                    .onTapGesture {
                        if interactive {
                            rating = star
                        }
                    }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: .constant(3))
        StarRatingView(rating: 4, interactive: false)
    }
    .padding()
}
