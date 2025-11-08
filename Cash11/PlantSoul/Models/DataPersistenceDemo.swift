import Foundation

class DataPersistenceDemo {
    
    static func runDemo() {
        print("🌱 Демонстрация системы сохранения данных PlantSoul")
        print("=" * 50)
        
        let testPlant = Plant(
            name: "Тестовое растение",
            category: .indoor,
            notes: "Это тестовое растение для демонстрации"
        )
        
        let testTask = Task(
            plantId: testPlant.id,
            plantName: testPlant.name,
            type: .watering,
            date: Date(),
            description: "Тестовая задача полива"
        )
        
        let testInstruction = Instruction(
            title: "Тестовая инструкция",
            description: "Это тестовая инструкция для демонстрации",
            type: .watering,
            requiredItems: ["Лейка", "Вода"],
            steps: [
                InstructionStep(stepNumber: 1, title: "Шаг 1", description: "Проверить почву"),
                InstructionStep(stepNumber: 2, title: "Шаг 2", description: "Полить растение")
            ]
        )
        
        print("📝 Тестирование сохранения данных...")
        let dataManager = DataManager.shared
        
        dataManager.savePlants([testPlant])
        dataManager.saveTasks([testTask])
        dataManager.saveInstructions([testInstruction])
        dataManager.saveOnboardingStatus(true)
        
        print("✅ Данные сохранены успешно")
        
        print("\n📖 Тестирование загрузки данных...")
        
        let loadedPlants = dataManager.loadPlants()
        let loadedTasks = dataManager.loadTasks()
        let loadedInstructions = dataManager.loadInstructions()
        let onboardingStatus = dataManager.loadOnboardingStatus()
        
        print("✅ Загружено растений: \(loadedPlants.count)")
        print("✅ Загружено задач: \(loadedTasks.count)")
        print("✅ Загружено инструкций: \(loadedInstructions.count)")
        print("✅ Статус онбординга: \(onboardingStatus ? "Завершен" : "Не завершен")")
        
        print("\n💾 Тестирование резервного копирования...")
        
        if let backup = DataBackup.createBackup() {
            print("✅ Резервная копия создана успешно")
            print("📊 Размер резервной копии: \(backup.sizeFormatted)")
            print("📅 Дата создания: \(DateFormatter.localizedString(from: backup.date, dateStyle: .medium, timeStyle: .short))")
            
            print("\n🔄 Тестирование восстановления из резервной копии...")
            
            dataManager.clearAllData()
            print("🗑️ Данные очищены")
            
            if DataBackup.restoreFromBackup(backup) {
                print("✅ Данные восстановлены из резервной копии")
                
                let restoredPlants = dataManager.loadPlants()
                let restoredTasks = dataManager.loadTasks()
                let restoredInstructions = dataManager.loadInstructions()
                
                print("✅ Восстановлено растений: \(restoredPlants.count)")
                print("✅ Восстановлено задач: \(restoredTasks.count)")
                print("✅ Восстановлено инструкций: \(restoredInstructions.count)")
            } else {
                print("❌ Ошибка при восстановлении данных")
            }
        } else {
            print("❌ Ошибка при создании резервной копии")
        }
        
        print("\n🎉 Демонстрация завершена!")
        print("=" * 50)
    }
    
    static func validateDataIntegrity() -> Bool {
        let dataManager = DataManager.shared
        
        let plants = dataManager.loadPlants()
        let tasks = dataManager.loadTasks()
        let instructions = dataManager.loadInstructions()
        
        let plantIds = Set(plants.map { $0.id })
        let hasUniquePlantIds = plantIds.count == plants.count
        
        let taskIds = Set(tasks.map { $0.id })
        let hasUniqueTaskIds = taskIds.count == tasks.count
        
        let instructionIds = Set(instructions.map { $0.id })
        let hasUniqueInstructionIds = instructionIds.count == instructions.count
        
        let existingPlantIds = Set(plants.map { $0.id })
        let validTaskReferences = tasks.allSatisfy { existingPlantIds.contains($0.plantId) }
        
        let isValid = hasUniquePlantIds && hasUniqueTaskIds && hasUniqueInstructionIds && validTaskReferences
        
        if !isValid {
            print("⚠️ Обнаружены проблемы с целостностью данных:")
            if !hasUniquePlantIds { print("  - Дублирующиеся ID растений") }
            if !hasUniqueTaskIds { print("  - Дублирующиеся ID задач") }
            if !hasUniqueInstructionIds { print("  - Дублирующиеся ID инструкций") }
            if !validTaskReferences { print("  - Задачи ссылаются на несуществующие растения") }
        }
        
        return isValid
    }
}

extension String {
    static func * (left: String, right: Int) -> String {
        return String(repeating: left, count: right)
    }
}
