//
//  HealthError.swift
//
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

public enum HealthError: Error {
    case notAuthorized
    case cantSaveEmpty
    case noDataFound
    case somethingWentWrong
}
