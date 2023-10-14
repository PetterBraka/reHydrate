//
//  LocalizedString.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

func LocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle = Bundle.main,
    value: String,
    comment: String
) -> String {
    NSLocalizedString(
        key,
        tableName: tableName,
        bundle: bundle,
        value: value,
        comment: comment
    )
}

func LocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle = Bundle.main,
    value: String,
    arguments: CVarArg...,
    comment: String
) -> String {
    String(
        format: NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            value: value,
            comment: comment
        ), 
        arguments: arguments
    )
}

func LocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle = Bundle.main,
    value: String,
    arguments: [CVarArg],
    comment: String
) -> String {
    String(
        format: NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            value: value,
            comment: comment
        ),
        arguments: arguments
    )
}
