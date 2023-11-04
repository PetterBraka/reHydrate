//
//  OpenUrlError.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

public enum OpenUrlError: Error {
    case urlCantBeOpened
    case invalidUrl(String)
}
