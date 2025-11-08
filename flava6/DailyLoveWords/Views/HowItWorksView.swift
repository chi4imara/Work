import SwiftUI

struct HowItWorksView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        instructionSections
                        
                        footerView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("How It Works")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
    
    private var headerView: some View {
        PixelCard {
            VStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("How It Works")
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Learn how to build your personal word collection")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 10)
        }
    }
    
    private var instructionSections: some View {
        VStack(spacing: 20) {
            InstructionCard(
                icon: "calendar",
                title: "Daily Words",
                description: "Each day you can add one new word to your collection. The word is automatically dated for that day."
            )
            
            InstructionCard(
                icon: "textformat.abc",
                title: "Required Field",
                description: "The 'Word' field is required - you must enter at least one word to save an entry."
            )
            
            InstructionCard(
                icon: "globe",
                title: "Optional Translation",
                description: "You can add a translation in any language. This field is optional and can be filled later."
            )
            
            InstructionCard(
                icon: "note.text",
                title: "Optional Comments",
                description: "Add notes, context, or examples to help you remember the word better. This is also optional."
            )
            
            InstructionCard(
                icon: "books.vertical",
                title: "Your Collection",
                description: "All words are saved in your collection where you can view, edit, or delete them anytime."
            )
            
            InstructionCard(
                icon: "heart.fill",
                title: "Personal Dictionary",
                description: "Over time, you'll build your own personalized dictionary that grows with your learning journey."
            )
        }
    }
    
    private var footerView: some View {
        PixelCard {
            VStack(spacing: 16) {
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.pixelYellow)
                
                Text("Start Building Today!")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Your word collection journey begins with just one word. Start today and watch your vocabulary grow!")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                
                PixelButton(
                    title: "Got It!",
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    color: AppColors.primaryBlue
                )
            }
            .padding(.vertical, 10)
        }
    }
}

struct InstructionCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        PixelCard {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(description)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    HowItWorksView()
}
