//
//  TagCloudView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

// Ref: https://medium.com/engineering-askapro/implementing-generic-tag-cloud-in-swiftui-c0877a19b800

struct TagCloudView: View {
    let tags: [Item.Tag]
    let onTapTag: (UUID) -> Void

    var body: some View {
        TagStackLayout {
            ForEach(tags) { tag in
                TagButtonView(
                    tagName: tag.name,
                    onTapTag: { onTapTag(tag.id) }
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 0)
    }
}

private struct TagButtonView: View {
    let tagName: String
    let onTapTag: () -> Void

    var body: some View {
        Button(action: {
            onTapTag()
        }, label: {
            Text(tagName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        })
    }
}

private struct TagStackLayout: Layout {
    private let spacing: CGFloat

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0

        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = maxViewHeight
        var totalWidth: CGFloat = 0

        sizes.forEach { size in
            if currentRowWidth + spacing + size.width > proposal.width ?? 0 {
                totalHeight += spacing + maxViewHeight
                currentRowWidth = size.width
            } else {
                currentRowWidth += spacing + size.width
            }
            totalWidth = max(totalWidth, currentRowWidth)
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0

        var point = CGPoint(x: bounds.minX, y: bounds.minY)
        subviews.indices.forEach { index in
            if point.x + sizes[index].width > bounds.maxX {
                point.x = bounds.minX
                point.y += maxViewHeight + spacing
            }
            subviews[index].place(at: point, proposal: .init(sizes[index]))
            point.x += sizes[index].width + spacing
        }
    }
}

#Preview {
    let tags = [
        Item.Tag(name: "Supabase"),
        Item.Tag(name: "Firebase"),
        Item.Tag(name: "Apple Vision Pro"),
        Item.Tag(name: "TypeScript"),
        Item.Tag(name: "SwiftUI"),
    ]
    TagCloudView(tags: tags) { _ in }
}
