import Foundation

class CareAdviceDataManager {
    static let shared = CareAdviceDataManager()
    
    private init() {}
    
    func getAllAdvice() -> [CareAdvice] {
        return [
            CareAdvice(
                id: "a1",
                title: "How to Water Houseplants Correctly",
                description: "Learn timing, amounts, and methods to avoid over/underwatering.",
                content: "# Watering Basics\n## Check Soil Moisture\n- Insert your finger 2-3cm into soil; water if dry.\n- Use a moisture meter for precision.\n## Watering Amount\n- Water until excess drains from bottom.\n- Empty saucer after 10 minutes.\n## Seasonal Adjustments\n- Reduce watering in winter.\n- Increase during active growth.",
                category: .watering
            ),
            CareAdvice(
                id: "a2",
                title: "Repotting 101",
                description: "When and how to repot without stressing your plant.",
                content: "# When to Repot\n- Roots circling pot or coming out of holes.\n- Water runs straight through soil.\n# Steps\n- Choose a pot 2-3cm wider.\n- Loosen roots gently.\n- Use fresh, suitable mix.",
                category: .repotting
            ),
            CareAdvice(
                id: "a3",
                title: "Beginner-friendly Fertilizing",
                description: "Simple schedule and safe dosages to boost growth.",
                content: "# Fertilizer Types\n- Balanced liquid for most houseplants.\n## Frequency\n- Monthly in spring-summer.\n- Skip in winter.\n## Safety\n- Always dilute to half strength.",
                category: .fertilizing
            ),
            CareAdvice(
                id: "a4",
                title: "Finding the Right Light",
                description: "Place plants for optimal light without burning leaves.",
                content: "# Light Levels\n- Bright indirect near east/north windows.\n- Avoid harsh midday sun.\n## Tips\n- Rotate pots weekly.\n- Use sheer curtains if needed.",
                category: .lighting
            ),
            CareAdvice(
                id: "a5",
                title: "Preventing Common Diseases",
                description: "Habits that keep fungal and bacterial issues at bay.",
                content: "# Hygiene\n- Remove dead foliage promptly.\n- Sterilize tools.\n# Airflow\n- Space plants for ventilation.\n# Watering\n- Avoid wetting leaves at night.",
                category: .diseases
            ),
            CareAdvice(
                id: "a6",
                title: "General Care Checklist",
                description: "A monthly routine to keep plants thriving.",
                content: "# Monthly Tasks\n- Dust leaves.\n- Check for pests.\n- Prune leggy growth.\n- Refresh topsoil.",
                category: .general
            )
        ]
    }
}


