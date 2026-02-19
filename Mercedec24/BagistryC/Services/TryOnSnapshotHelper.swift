import UIKit

enum TryOnSnapshotHelper {
    static func makeSnapshotImage(bag: Bag, isFrontCamera: Bool) -> UIImage {
        let size = CGSize(width: 600, height: 800)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            let gradientColors = [
                UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1).cgColor,
                UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1).cgColor
            ]
            if let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: gradientColors as CFArray,
                locations: [0, 1]
            ) {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
            
            let bagImage: UIImage?
            if !bag.imageURL.isEmpty {
                bagImage = BagPhotoStorage.loadImage(filename: bag.imageURL)
            } else {
                bagImage = nil
            }
            
            let imageRect = CGRect(x: 100, y: 120, width: 400, height: 400)
            if let img = bagImage {
                img.draw(in: imageRect)
            } else {
                UIColor.black.withAlphaComponent(0.3).setFill()
                context.cgContext.fill(imageRect)
                let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
                let icon = UIImage(systemName: "handbag.fill", withConfiguration: config)?
                    .withTintColor(UIColor(red: 1, green: 0.8, blue: 0.2, alpha: 1), renderingMode: .alwaysOriginal)
                icon?.draw(in: imageRect.insetBy(dx: 120, dy: 120))
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let titleAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            "AR Try-On".draw(in: CGRect(x: 0, y: 540, width: size.width, height: 36), withAttributes: titleAttr)
            
            let bagNameAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            (bag.name.isEmpty ? " " : bag.name).draw(in: CGRect(x: 0, y: 580, width: size.width, height: 28), withAttributes: bagNameAttr)
            
            let brandAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor(red: 1, green: 0.8, blue: 0.2, alpha: 1),
                .paragraphStyle: paragraphStyle
            ]
            (bag.brand.isEmpty ? " " : bag.brand).draw(in: CGRect(x: 0, y: 612, width: size.width, height: 22), withAttributes: brandAttr)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let dateStr = formatter.string(from: Date())
            let dateAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                .paragraphStyle: paragraphStyle
            ]
            dateStr.draw(in: CGRect(x: 0, y: 650, width: size.width, height: 18), withAttributes: dateAttr)
            
            let cameraLabel = isFrontCamera ? "Front camera" : "Back camera"
            cameraLabel.draw(in: CGRect(x: 0, y: 680, width: size.width, height: 16), withAttributes: dateAttr)
        }
    }
}
