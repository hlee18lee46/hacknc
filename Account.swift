// Account.swift
import Foundation

struct Account: Codable, Identifiable {
    var id: String { account_id }
    let account_id: String
    let name: String
    let mask: String
    let subtype: String
    let type: String
    let balances: Balance
}

struct Balance: Codable {
    let available: Double?
    let current: Double
    let limit: Double?
}

struct AccountsResponse: Codable {
    let accounts: [Account]
}
