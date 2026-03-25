import Foundation
import UIKit

struct OpenAIClient: AIClientProtocol {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - System Prompt
    private let systemPrompt = """
    You are a professional nutritionist and food composition expert \
    embedded in a mobile calorie tracking app used by health-conscious \
    individuals tracking their daily food intake. Your task is to analyze \
    a photograph of a meal and estimate its macronutrient content as \
    accurately as possible.

    ## Analysis Process

    Follow this reasoning chain for every image:

    1. Identify every distinct food item visible in the image.
    2. Estimate portion size for each item in grams, using visual cues:
       - Use the plate/bowl/container as a size reference (standard \
    dinner plate ≈ 26cm diameter).
       - Consider the depth/height of food piles.
       - Account for food density (e.g., rice is denser than salad greens).
    3. Determine preparation method (fried, grilled, steamed, raw, etc.) \
    as this significantly affects fat and calorie content.
    4. Account for hidden calories: cooking oils, butter, sauces, dressings, \
    cheese, and sugar that may not be visually obvious but are commonly \
    used in the preparation of the identified dish.
    5. Calculate macronutrients for each item using standard nutritional \
    databases (USDA FoodData Central as reference), then sum totals.
    6. Assess your confidence based on: image clarity, food identifiability, \
    portion visibility, and whether hidden ingredients are likely.

    ## Rules

    - If the user provides a text description, use it to REFINE your visual \
    analysis. The description takes priority for: ingredient identification, \
    cooking method, and approximate quantity. However, if the description \
    clearly contradicts what is visible, note the discrepancy and estimate \
    based on what you SEE, explaining the conflict in "notes".
    - Always estimate on the CONSERVATIVE side — it is better to slightly \
    overestimate calories than to underestimate.
    - Never return zero values for calories unless the image clearly shows \
    only water or a zero-calorie beverage.
    - For opaque or colored drinks (smoothies, juices, coffee with milk, \
    alcohol), assume significant calories unless clearly zero-calorie. \
    A 300ml smoothie typically contains 150-300 kcal.
    - If you cannot identify the food at all, set confidence below 0.3 \
    and explain in notes.
    - Protein, carbs, and fat values must be internally consistent with \
    calories: calories ≈ (protein × 4) + (carbs × 4) + (fat × 9). \
    If your estimates deviate more than 15% from this formula, re-check.
    - Round calories to the nearest 5. Round macros to 1 decimal place.
    - For the description field: write 1-2 sentences describing what you \
    see visually — the food, its apparent preparation method, and \
    presentation. This is shown in the app's meal card UI.

    ## Confidence Score Guidelines

    - 0.8–1.0: Simple, clearly visible foods (banana, plain rice, grilled chicken)
    - 0.6–0.79: Identifiable dish with some uncertainty (pasta with sauce, stir-fry)
    - 0.4–0.59: Complex or partially obscured dish (casserole, wrapped food)
    - 0.2–0.39: Difficult to identify, very uncertain (blurry photo, unknown dish)
    - Below 0.2: Cannot meaningfully estimate

    You must respond with valid JSON matching the required schema. \
    Do not include any text outside the JSON object.
    """

    // MARK: - JSON Schema for Structured Outputs
    private var responseSchema: [String: Any] {
        [
            "type": "json_schema",
            "json_schema": [
                "name": "food_analysis",
                "strict": true,
                "schema": [
                    "type": "object",
                    "properties": [
                        "name": ["type": "string"],
                        "description": ["type": "string"],
                        "calories": ["type": "number"],
                        "protein": ["type": "number"],
                        "carbs": ["type": "number"],
                        "fat": ["type": "number"],
                        "confidence": ["type": "number"],
                        "notes": ["type": "string"]
                    ],
                    "required": ["name", "description", "calories",
                                 "protein", "carbs", "fat", "confidence", "notes"],
                    "additionalProperties": false
                ]
            ]
        ]
    }

    // MARK: - analyzeFoodImage
    func analyzeFoodImage(
        _ imageData: Data,
        userDescription: String?
    ) async throws -> FoodAnalysisResult {

        let compressed = try compressImage(imageData)
        let base64 = compressed.base64EncodedString()

        var userText = "Analyze the food in this image and estimate its nutritional content."
        if let desc = userDescription, !desc.trimmingCharacters(in: .whitespaces).isEmpty {
            userText += "\n\nAdditional context from the user: \"\(desc)\""
        }
        userText += "\n\nReturn your analysis as a JSON object with these exact fields: name, description, calories, protein, carbs, fat, confidence, notes."

        let body: [String: Any] = [
            "model": "gpt-4o",
            "temperature": 0.1,
            "max_tokens": 500,
            "response_format": responseSchema,
            "messages": [
                ["role": "system", "content": systemPrompt],
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64)",
                                "detail": "auto"
                            ]
                        ],
                        [
                            "type": "text",
                            "text": userText
                        ]
                    ]
                ]
            ]
        ]

        let data = try await performRequest(body: body)
        return try parseAnalysisResponse(data)
    }

    // MARK: - analyzeNutritionLabel
    func analyzeNutritionLabel(_ imageData: Data) async throws -> MacroNutrients {
        // Phase 3.3 — placeholder
        throw AIAnalysisError.malformedResponse("Nutrition label scan not yet implemented")
    }

    // MARK: - Image compression
    private func compressImage(_ data: Data) throws -> Data {
        guard let uiImage = UIImage(data: data) else {
            throw AIAnalysisError.malformedResponse("Could not decode image")
        }

        // Fix EXIF orientation
        let normalized = uiImage.fixedOrientation()

        // Resize to max 1024px on long edge
        let resized = normalized.resizedToMaxDimension(1024)

        guard let jpeg = resized.jpegData(compressionQuality: 0.85) else {
            throw AIAnalysisError.imageTooLarge
        }
        return jpeg
    }

    // MARK: - Network request
    private func performRequest(body: [String: Any]) async throws -> Data {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw AIAnalysisError.malformedResponse("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AIAnalysisError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw AIAnalysisError.malformedResponse("No HTTP response")
        }

        switch http.statusCode {
        case 200:
            return data
        case 401:
            throw AIAnalysisError.invalidAPIKey
        case 429:
            throw AIAnalysisError.rateLimitExceeded
        default:
            throw AIAnalysisError.malformedResponse("HTTP \(http.statusCode)")
        }
    }

    // MARK: - Response parsing
    private func parseAnalysisResponse(_ data: Data) throws -> FoodAnalysisResult {
        struct OpenAIResponse: Decodable {
            struct Choice: Decodable {
                struct Message: Decodable {
                    let content: String
                }
                let message: Message
            }
            let choices: [Choice]
        }

        struct RawResult: Decodable {
            let name: String
            let description: String
            let calories: Double
            let protein: Double
            let carbs: Double
            let fat: Double
            let confidence: Double
            let notes: String
        }

        guard let openAIResponse = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
              let content = openAIResponse.choices.first?.message.content,
              let contentData = content.data(using: .utf8),
              let raw = try? JSONDecoder().decode(RawResult.self, from: contentData)
        else {
            throw AIAnalysisError.malformedResponse("Could not parse response")
        }

        // Validate macro consistency:
        // |calories - (p*4 + c*4 + f*9)| / calories must be < 0.20
        let calculatedCalories = (raw.protein * 4) + (raw.carbs * 4) + (raw.fat * 9)
        if raw.calories > 0 {
            let deviation = abs(raw.calories - calculatedCalories) / raw.calories
            if deviation > 0.20 {
                throw AIAnalysisError.macroInconsistency
            }
        }

        // Flag unrecognized food
        if raw.confidence < 0.2 {
            throw AIAnalysisError.unrecognizedFood
        }

        let macros = MacroNutrients(
            calories: raw.calories,
            protein: raw.protein,
            carbs: raw.carbs,
            fat: raw.fat
        )

        return FoodAnalysisResult(
            name: raw.name,
            description: raw.description,
            macros: macros,
            confidence: raw.confidence,
            notes: raw.notes
        )
    }
}
