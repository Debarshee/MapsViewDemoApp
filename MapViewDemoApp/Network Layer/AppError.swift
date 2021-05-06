//
//  AppError.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/28/21.
//

import Foundation

enum AppError: Error {
    case invalidUrl
    case serverError
    case badResponse
    case noData
    case parseError
    case badRequest
    case genericError(String)
}
