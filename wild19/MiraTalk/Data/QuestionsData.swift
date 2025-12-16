import Foundation

class QuestionsData {
    static let shared = QuestionsData()
    
    private init() {}
    
    let allQuestions: [Question] = [
        Question(text: "What's the most interesting place you've ever visited?", category: .introduction),
        Question(text: "If you could have dinner with anyone, living or dead, who would it be?", category: .introduction),
        Question(text: "What's your favorite way to spend a weekend?", category: .introduction),
        Question(text: "What's something you've learned recently that surprised you?", category: .introduction),
        Question(text: "What's your biggest dream or goal right now?", category: .introduction),
        
        Question(text: "What's the funniest thing that happened to you this week?", category: .company),
        Question(text: "If you could switch lives with anyone for a day, who would it be?", category: .company),
        Question(text: "What's your most embarrassing moment?", category: .company),
        Question(text: "What's the weirdest food combination you actually enjoy?", category: .company),
        Question(text: "If you had to eat one meal for the rest of your life, what would it be?", category: .company),
        
        Question(text: "What's something you're really proud of but don't get to talk about much?", category: .personal),
        Question(text: "What's the best advice you've ever received?", category: .personal),
        Question(text: "What's something you wish you could tell your younger self?", category: .personal),
        Question(text: "What's your biggest fear and how do you deal with it?", category: .personal),
        Question(text: "What's a skill you wish you had?", category: .personal),
        
        Question(text: "If animals could talk, which species would be the rudest?", category: .funny),
        Question(text: "What's the most ridiculous fact you know?", category: .funny),
        Question(text: "If you were a superhero, what would your useless superpower be?", category: .funny),
        Question(text: "What's the strangest thing you believed as a child?", category: .funny),
        Question(text: "If you could rename yourself, what name would you choose?", category: .funny),
        
        Question(text: "Do you think everything happens for a reason?", category: .philosophical),
        Question(text: "What do you think is the meaning of life?", category: .philosophical),
        Question(text: "If you could know the absolute truth about one thing, what would it be?", category: .philosophical),
        Question(text: "Do you believe in free will or is everything predetermined?", category: .philosophical),
        Question(text: "What makes a person truly happy?", category: .philosophical),
        
        Question(text: "If you could have any animal as a pet, what would it be?", category: .forKids),
        Question(text: "What's your favorite game to play?", category: .forKids),
        Question(text: "If you could fly anywhere in the world, where would you go?", category: .forKids),
        Question(text: "What's your favorite color and why?", category: .forKids),
        Question(text: "If you could be any character from a movie, who would you be?", category: .forKids)
    ]
    
    let collections: [QuestionCollection] = [
        QuestionCollection(
            title: "For First Date",
            icon: "heart",
            questions: [
                Question(text: "What's your idea of a perfect day?", category: .personal),
                Question(text: "What's something you're passionate about?", category: .personal),
                Question(text: "What's your favorite travel destination?", category: .introduction),
                Question(text: "What's the best book you've read recently?", category: .introduction),
                Question(text: "What's your biggest goal for this year?", category: .personal)
            ]
        ),
        QuestionCollection(
            title: "For Party",
            icon: "party.popper",
            questions: [
                Question(text: "What's your most embarrassing moment?", category: .funny),
                Question(text: "If you could have any superpower, what would it be?", category: .funny),
                Question(text: "What's the weirdest thing you've ever eaten?", category: .company),
                Question(text: "What's your hidden talent?", category: .company),
                Question(text: "If you were famous, what would you be famous for?", category: .funny)
            ]
        ),
        QuestionCollection(
            title: "With Friends",
            icon: "person.3",
            questions: [
                Question(text: "What's the craziest thing you've ever done?", category: .company),
                Question(text: "What's your biggest pet peeve?", category: .personal),
                Question(text: "If you could live in any time period, when would it be?", category: .philosophical),
                Question(text: "What's your favorite childhood memory?", category: .personal),
                Question(text: "What's something you've always wanted to try?", category: .introduction)
            ]
        ),
        QuestionCollection(
            title: "With Kids",
            icon: "figure.child",
            questions: [
                Question(text: "If you could have any animal as a pet, what would it be?", category: .forKids),
                Question(text: "What's your favorite game to play?", category: .forKids),
                Question(text: "If you could fly anywhere, where would you go?", category: .forKids),
                Question(text: "What's your favorite color and why?", category: .forKids),
                Question(text: "If you could be any character from a movie, who would you be?", category: .forKids)
            ]
        ),
        QuestionCollection(
            title: "Philosophical",
            icon: "brain.head.profile",
            questions: [
                Question(text: "Do you think everything happens for a reason?", category: .philosophical),
                Question(text: "What do you think is the meaning of life?", category: .philosophical),
                Question(text: "What makes a person truly happy?", category: .philosophical),
                Question(text: "Do you believe in free will?", category: .philosophical),
                Question(text: "What's the most important lesson life has taught you?", category: .philosophical)
            ]
        ),
        QuestionCollection(
            title: "Funny",
            icon: "face.smiling",
            questions: [
                Question(text: "If animals could talk, which would be the rudest?", category: .funny),
                Question(text: "What's the most ridiculous fact you know?", category: .funny),
                Question(text: "If you were a superhero, what would your useless power be?", category: .funny),
                Question(text: "What's the strangest thing you believed as a child?", category: .funny),
                Question(text: "If you could rename yourself, what name would you choose?", category: .funny)
            ]
        )
    ]
}
