//
//  Alerta.swift
//  Food list
//
//  Created by Fabio Oliveira on 27/02/23.
//

import Foundation
import UIKit

class Alerta {
    
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func exibe(title: String = "Desculpe", mensagem: String) {
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        alerta.addAction(ok)
        controller.present(alerta, animated: true)
        
    }
    
}
