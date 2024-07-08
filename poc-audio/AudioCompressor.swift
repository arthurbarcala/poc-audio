import AVFoundation
import UIKit

//enum para o resultado da compressão
public enum CompressionResult {
    case onStart
    case onSuccess(URL)
    case onFailure(CompressionError)
}

//struct para erros
public struct CompressionError: Error {
    public let description: String
}
    
public func compressAudio(source: URL, destination: URL, completion: @escaping (CompressionResult) -> ()) -> Void {
    completion(.onStart)

    //Criação do asset, para permitir a manipulação
    let audioAsset = AVURLAsset(url: source)

    //Criando uma exportSession a partir do asset, utilizando um preset LowQuality para diminuir a qualidade do arquivo
    let exportSession = AVAssetExportSession(asset: audioAsset, presetName: AVAssetExportPresetLowQuality)
    exportSession?.outputURL = destination
    exportSession?.outputFileType = .mov

    //Chamando a função
    exportSession?.exportAsynchronously {
        //Tratatia de erros de acordo com o resultado
        switch exportSession?.status {
        case .completed:
            completion(.onSuccess(destination))
        case .failed:
            let error = CompressionError(description: exportSession?.error?.localizedDescription ?? "Erro desconhecido")
            completion(.onFailure(error))
        default:
            break
        }
    }
}
