import Foundation

enum SampleData {
    
    static let principleTexts: [String] = [
        "Be honest with yourself and others, even when it is difficult.",
        "Treat others the way you want to be treated.",
        "Focus on what you can control; let go of the rest.",
        "Learn something new every day.",
        "Say no to things that do not align with your values.",
        "Take responsibility for your actions and their consequences.",
        "Listen more than you speak.",
        "Choose progress over perfection.",
        "Rest when your body and mind need it.",
        "Stand up for what is right, even when it is uncomfortable.",
        "Give credit where it is due; share success with others.",
        "Ask for help when you need it.",
        "Keep your word once you give it.",
        "Spend time with people who lift you up.",
        "Review your decisions regularly and adjust when needed."
    ]
    
    static func principlesWithPastDates(calendar: Calendar = .current) -> [(text: String, daysAgo: Int)] {
        [
            (principleTexts[0], 2),
            (principleTexts[1], 5),
            (principleTexts[2], 1),
            (principleTexts[3], 10),
            (principleTexts[4], 3),
            (principleTexts[5], 7),
            (principleTexts[6], 0),
            (principleTexts[7], 14),
            (principleTexts[8], 4),
            (principleTexts[9], 21),
            (principleTexts[10], 6),
            (principleTexts[11], 9),
            (principleTexts[12], 1),
            (principleTexts[13], 12),
            (principleTexts[14], 8)
        ]
    }
}
