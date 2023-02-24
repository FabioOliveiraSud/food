//
//  AdicionarItensViewController.swift
//  Food list
//
//  Created by Fabio Oliveira on 01/02/23.
//

import UIKit

protocol AdiconaItensDelegate {
    func add(_ item: Item)
}

class AdicionarItensViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var caloriasTextField: UITextField!
    
    // MARK: - Atributos
    
    var delegate: AdiconaItensDelegate?
    
    init(delegate: AdiconaItensDelegate) {
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func adicionarItem(_ sender: UIButton) {
        
        guard let nome = nomeTextField.text, let calorias = caloriasTextField.text else {return}
        
        if let numeroDeCalorias = Double(calorias) {
            let item = Item(nome: nome, calorias: numeroDeCalorias)
            delegate?.add(item)
            navigationController?.popViewController(animated: true)
        }
    }
}
