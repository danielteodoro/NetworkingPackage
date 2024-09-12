import Foundation
import NetworkingPackage

struct PokemonService: Networkable {
//    static func fetchPokemonList(limit: Int, offset: Int, resultHandler: @escaping (Result<PokemonListing, NetworkError>) -> Void) {
//        Self.sendRequest(
//            endpoint: PokemonEndpoint.list(limit, offset),
//            with: PokemonListing.self,
//            resultHandler: resultHandler
//        )
//    }
//    
//    static func fetchPokemonByName(name: String, resultHandler: @escaping (Result<PokemonModel, NetworkError>) -> Void) {
//        .task {
//            Self.sendRequest(
//                endpoint: PokemonEndpoint.pokemonByName(name),
//                with: PokemonModel.self,
//                resultHandler: resultHandler
//            )
//        }
//    }
//    
    static func fetchPokemonByID(id: Int) async throws -> PokemonModel {
        do {
            let pokemon = try await Self.sendRequest(type: PokemonModel.self, endpoint: PokemonEndpoint.pokemonByID(id))
            print(pokemon)
            return pokemon
        } catch {
            print("error")
            throw NetworkError.emptyData
        }
    }
}
