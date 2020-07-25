//
//  SecretManager.swift
//  Twittermenti
//
//  Created by Marina Romanova on 25/07/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation

class PlistManager {

	/**
	consumerKey: PlistManager.getPlist(withName: "Secret")![0]
	*/
	class func getPlist(withName name: String) -> [String]? {
		if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
			let xml = FileManager.default.contents(atPath: path)
		{
			return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
		}

		return nil
	}

	class func getSecrets() -> Secrets? {
		if  let path        = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
			let xml         = FileManager.default.contents(atPath: path),
			let secrets = try? PropertyListDecoder().decode(Secrets.self, from: xml) {

			return secrets
		} else {
			return nil

		}
	}

	class func getApiKey() -> String? {
		getSecrets()?.apiKey
	}

	class func getApiSecret() -> String? {
		getSecrets()?.apiSecret
	}
}

struct Secrets: Codable {
	var apiKey: String
	var apiSecret: String
}
