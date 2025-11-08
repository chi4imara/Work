import SwiftUI

struct FontTestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Font Test")
                .font(.theme.largeTitle)
            
            Text("Raleway Light")
                .font(.theme.caption2)
            
            Text("Raleway Regular")
                .font(.theme.body)
            
            Text("Raleway Medium")
                .font(.theme.subheadline)
            
            Text("Raleway SemiBold")
                .font(.theme.headline)
            
            Text("Raleway Bold")
                .font(.theme.title1)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Loaded Fonts:")
                    .font(.theme.headline)
                
                ForEach(FontManager.shared.getAvailableFonts(), id: \.self) { fontName in
                    Text("✓ \(fontName)")
                        .font(.theme.caption1)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    FontTestView()
}
