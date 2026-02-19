import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    let size: CGFloat
    let interactive: Bool
    
    init(rating: Binding<Int>, size: CGFloat = 20, interactive: Bool = true) {
        self._rating = rating
        self.size = size
        self.interactive = interactive
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                if interactive {
                    Button(action: {
                        rating = star
                    }) {
                        starImage(for: star)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    starImage(for: star)
                }
            }
        }
    }
    
    private func starImage(for star: Int) -> some View {
        Image(systemName: star <= rating ? "star.fill" : "star")
            .font(.system(size: size))
            .foregroundColor(star <= rating ? .primaryYellow : .textSecondary)
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: .constant(3), size: 24, interactive: true)
        StarRatingView(rating: .constant(4), size: 20, interactive: false)
    }
    .padding()
    .background(Color.black)
}