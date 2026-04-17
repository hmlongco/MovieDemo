//
//  MovieServiceProtocol.swift
//  Construkt
//
//  Created by Michael Long on 4/10/26.
//

import Foundation

@MainActor
public protocol MovieServices: Sendable {
    func getPopularMovies(page: Int) async throws -> MovieResponse
    func getTopRatedMovies(page: Int) async throws -> MovieResponse
    func getNowPlayingMovies(page: Int) async throws -> MovieResponse
    func getMovieDetails(id: Int) async throws -> MovieDetail
    func getMovieCredits(id: Int) async throws -> CreditsResponse
    func getGenres() async throws -> GenreResponse
    func discoverMovies(page: Int, genreId: Int?) async throws -> MovieResponse
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
}

