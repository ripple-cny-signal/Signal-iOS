//
// Copyright 2024 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

extension AttachmentManager {

    /// Builds a ``SSKProtoAttachmentPointer`` for sending with a message,
    /// given both the pointer (an already-uploaded attachment) and the reference to
    /// that pointer from the parent message we want to send.
    public func buildProtoForSending(
        from reference: AttachmentReference,
        pointer: AttachmentTransitPointer
    ) -> SSKProtoAttachmentPointer {
        let builder = SSKProtoAttachmentPointer.builder()

        builder.setCdnNumber(pointer.cdnNumber)
        builder.setCdnKey(pointer.cdnKey)

        builder.setContentType(pointer.attachment.mimeType)

        reference.sourceFilename.map(builder.setFileName(_:))

        var flags: SSKProtoAttachmentPointerFlags?
        switch reference.owner {
        case .message(.bodyAttachment(let metadata)):
            (metadata.caption?.text).map(builder.setCaption(_:))
            flags = metadata.renderingFlag.toProto()
        case .message(.quotedReply(let metadata)):
            flags = metadata.renderingFlag.toProto()
        case .storyMessage(.media(let metadata)):
            (metadata.caption?.text).map(builder.setCaption(_:))
            flags = metadata.shouldLoop ? .gif : nil
        default:
            break
        }

        if let flags {
            builder.setFlags(UInt32(flags.rawValue))
        } else {
            builder.setFlags(0)
        }

        func setMediaSizePixels(_ pixelSize: CGSize) {
            builder.setWidth(UInt32(pixelSize.width.rounded()))
            builder.setHeight(UInt32(pixelSize.width.rounded()))
        }

        if let stream = pointer.attachment.asStream() {
            // If we have it downloaded and have the validated values, use them.
            builder.setSize(stream.unenecryptedByteCount)

            switch stream.contentType {
            case .file, .audio:
                break
            case .image(let pixelSize), .animatedImage(let pixelSize), .video(_, let pixelSize):
                setMediaSizePixels(_: pixelSize)
            }
        } else {
            // Otherwise fall back to values from the sender.
            reference.sourceUnencryptedByteCount.map(builder.setSize(_:))
            reference.sourceMediaSizePixels.map(setMediaSizePixels(_:))
        }
        builder.setKey(pointer.info.encryptionKey)
        builder.setDigest(pointer.info.encryptedFileSha256Digest)

        pointer.attachment.blurHash.map(builder.setBlurHash(_:))

        return builder.buildInfallibly()
    }
}
