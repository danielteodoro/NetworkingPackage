import NetworkingPackage
import Foundation

enum PokemonEndpoint: EndPoint {
    case list(Int, Int)
    case pokemonByName(String)
    case pokemonByID(Int)
    
    var api: APIEnvironment.Type {
        return PokemonEnvoirement.self
    }
    
    internal var path: String {
        switch self {
        case .list:
            return "pokemon"
        case .pokemonByName(let name):
            return "pokemon/\(name)"
        case .pokemonByID(let id):
            return "pokemon/\(id)"
        }
    }
    
    var requestMethod: RequestMethod {
        return .get
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .list(let limit, let offset):
            return [URLQueryItem(name: "limit", value: limit.description),
                    URLQueryItem(name: "offset", value: offset.description)]
        default:
            return nil
        }
    }
}

class PokemonEnvoirement: APIEnvironment {
    static var baseURLString: String = "https://pokeapi.co/api/v2/"
}

struct PokemonListing: Codable {
    var count: Int
    var results: [PokemonListModel]
}

struct PokemonListModel: Codable {
    var name: String
}

struct PokemonModel: Codable {
    var id: Int
    var name: String
    var types: [PokemonTypeListing]
}

struct PokemonTypeListing: Codable {
    var slot: Int
    var type: PokemonType
}

struct PokemonType: Codable {
    var name: String
}
