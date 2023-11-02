//
//  OpenUrlPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import PortsInterface

final class OpenUrlPort: NSObject, OpenUrlServiceInterface {
    public private(set) var settingsUrl = URL(string: UIApplication.openSettingsURLString)
    
    @MainActor
    func open(url: URL) async throws {
        guard UIApplication.shared.canOpenURL(url) else {
            throw OpenUrlError.urlCantBeOpened
        }
        await UIApplication.shared.open(url)
    }
    
    func email(to email: String, cc: String?, bcc: String?,
               subject: String, body: String?) async throws {
        let queryItems = [
            URLQueryItem(name: "cc", value: cc),
            URLQueryItem(name: "bcc", value: bcc),
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body),
        ]
        var urlComponents = URLComponents(string: "mailto:\(email)")
        urlComponents?.queryItems = queryItems.filter { !($0.value?.isEmpty ?? true)  }
        guard let url = urlComponents?.url else {
            throw OpenUrlError.invalidUrl(urlComponents?.string ?? "Missing")
        }
        try await open(url: url)
    }
}
