//
//  ArticleRowView.swift
//  NewsApp
//


import SwiftUI

struct ArticleRowView: View {
    @EnvironmentObject var articleBookmarkViewModel: ArticleBookmarkViewModel
    let article: Article
    @State var isImageLoaded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            AsyncImage(url: article.articleImageURL){ phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10.0)
                        .onAppear {
                            isImageLoaded = true
                        }
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                    .onAppear {
                        isImageLoaded = false
                    }
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(isImageLoaded ? .clear : .gray.opacity(0.3))
            .cornerRadius(10.0)
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkViewModel.isBookmarked(article) ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkViewModel.isBookmarked(article) {
            articleBookmarkViewModel.removeBookmark(article)
        } else {
            articleBookmarkViewModel.addBookmark(article)
        }
    }
}

#Preview {
    ArticleRowView(
        article: Article.mockData.first!
    )
}
