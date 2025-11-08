import SwiftUI

struct FontTestView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Font Test Screen")
                    .font(.largeTitle)
                    .padding()
                
                Group {
                    Text("Poppins Regular")
                        .font(AppTheme.bodyFont)
                    
                    Text("Poppins Medium")
                        .font(AppTheme.buttonFont)
                    
                    Text("Poppins SemiBold")
                        .font(AppTheme.headlineFont)
                    
                    Text("Poppins Bold")
                        .font(AppTheme.titleFont)
                    
                    Text("Poppins Light")
                        .font(AppTheme.captionFont)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Group {
                    Text("Direct UIFont Test")
                        .font(.title2)
                    
                    if let regularFont = UIFont(name: "Poppins-Regular", size: 16) {
                        Text("UIFont Poppins Regular: \(regularFont.fontName)")
                            .font(Font(regularFont))
                    } else {
                        Text("❌ Poppins-Regular not found")
                            .foregroundColor(.red)
                    }
                    
                    if let mediumFont = UIFont(name: "Poppins-Medium", size: 16) {
                        Text("UIFont Poppins Medium: \(mediumFont.fontName)")
                            .font(Font(mediumFont))
                    } else {
                        Text("❌ Poppins-Medium not found")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                Group {
                    Text("FontManager Test")
                        .font(.title2)
                    
                    if FontManager.shared.isFontAvailable("Poppins-Regular") {
                        Text("✅ FontManager: Poppins-Regular available")
                            .foregroundColor(.green)
                    } else {
                        Text("❌ FontManager: Poppins-Regular not available")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            FontHelper.printAvailableFonts()
            FontManager.shared.printRegisteredFonts()
        }
    }
}

struct FontTestView_Previews: PreviewProvider {
    static var previews: some View {
        FontTestView()
    }
}
