//
//  File.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let exerciseForBodyPartResponse = try? JSONDecoder().decode(ExerciseForBodyPartResponse.self, from: jsonData)

import Foundation

// MARK: - ExerciseForBodyPartResponse

typealias ExerciseForBodyPartResponse = [ExerciseForBodyPart]

struct ExerciseForBodyPart: Codable {
    let bodyPart: String
    let equipment: String
    let gifURL: String
    let id, name: String
    let target: String

    enum CodingKeys: String, CodingKey {
        case bodyPart, equipment
        case gifURL = "gifUrl"
        case id, name, target
    }
}
