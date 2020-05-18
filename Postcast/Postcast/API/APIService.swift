//
//  APIService.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/10.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit
class APIService {
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    //singleton
    static let shared = APIService()
    let baseiTunesUrl = "https://itunes.apple.com/search"
    func downloadEpisode(episode: Episode) {
        //print("StreamURL:", episode.streamUrl)
        let destination = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streamUrl, to: destination)
            .downloadProgress { (progress) in
                NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
                print("Progres:", progress.fractionCompleted)
            }
        .response { response in
            debugPrint(response)
            if response.error == nil {
                print("Response.FileUrl",response.fileURL?.absoluteString ?? "")
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: response.fileURL?.absoluteString ?? "", episodeTitle: episode.title)
//                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
                var selectedIndex: Int? = 0
                for (idx, item) in downloadedEpisodes.enumerated() {
                    if item.description == episode.description && item.author == episode.author && item.title == episode.title {
//                        print("checked selected title:", item.title)
                        selectedIndex = idx
                    }
                }
                downloadedEpisodes[selectedIndex ?? 0].fileUrl = response.fileURL?.absoluteString ?? ""
                let data = try? JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
//                print("Userdefault download finished")
            }
        }
    }
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> Void) {
        let secureFeedUrl = feedUrl.toSecureHTTPS()
        guard let url = URL(string: secureFeedUrl) else { return }
        //FeedParser will block UI, synchronously
        // to resolve-> use background & async
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                switch result {
                case .success(let feed):
                    //use extensions RSSFeed.toEpisodes()
                    completionHandler(feed.rssFeed?.toEpisodes() ?? [])
                case .failure(let error):
                    print("Failed to fetch RSS", error)
                }
            }
        }
    }
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseiTunesUrl, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseData { (dataResp) in
            if let err = dataResp.error {
                print("Failed to contact url", err)
            }
            guard let data = dataResp.data else {return}
            do {
                let searchResult = try  JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
//                print("after completion")
//                self.podcasts = searchResult.results
            } catch let decodeErr {
                print("Failed to decode", decodeErr)
            }
        }
    }
}
