import SwiftUI

struct ConcaveShape: Shape {
    var cornerRadius: CGFloat = 20
    var depth: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        
        path.addCurve(to: CGPoint(x: width - cornerRadius, y: 0),
                     control1: CGPoint(x: width / 3, y: -depth),
                     control2: CGPoint(x: width * 2 / 3, y: -depth))
        
        path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: -90),
                   endAngle: Angle(degrees: 0),
                   clockwise: false)
        
        path.addCurve(to: CGPoint(x: width, y: height - cornerRadius),
                     control1: CGPoint(x: width + depth, y: height / 3),
                     control2: CGPoint(x: width + depth, y: height * 2 / 3))
        
        path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: 0),
                   endAngle: Angle(degrees: 90),
                   clockwise: false)
        
        path.addCurve(to: CGPoint(x: cornerRadius, y: height),
                     control1: CGPoint(x: width * 2 / 3, y: height + depth),
                     control2: CGPoint(x: width / 3, y: height + depth))
        
        path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: 90),
                   endAngle: Angle(degrees: 180),
                   clockwise: false)
        
        path.addCurve(to: CGPoint(x: 0, y: cornerRadius),
                     control1: CGPoint(x: -depth, y: height * 2 / 3),
                     control2: CGPoint(x: -depth, y: height / 3))
        
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: 180),
                   endAngle: Angle(degrees: 270),
                   clockwise: false)
        
        return path
    }
}

struct ConcaveModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var depth: CGFloat = 8
    var color: Color?
    
    func body(content: Content) -> some View {
        if let colorBackground = color {
            content
                .background(
                    ConcaveShape(cornerRadius: cornerRadius, depth: depth)
                        .fill(
                            colorBackground
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
        } else {
            content
                .background(
                    ConcaveShape(cornerRadius: cornerRadius, depth: depth)
                        .fill(
                            Color.white
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
        }
    }
}

extension View {
    func concaveCard(cornerRadius: CGFloat = 20, depth: CGFloat = 8, color: Color? = nil) -> some View {
        self.modifier(ConcaveModifier(cornerRadius: cornerRadius, depth: depth, color: color))
    }
}

struct ConcaveCard: View {
    var body: some View {
        VStack {
        }
        .frame(width: 300, height: 200)
        .concaveCard(cornerRadius: 0, depth: -10, color: .purple)
        
    
    }
}

#Preview {
    ConcaveCard()
}
