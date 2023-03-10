//
//  ViewController.swift
//  Food list
//
//  Created by Fabio Oliveira on 01/02/23.
//

import UIKit

protocol AdicionaRefeicaoDelegate {
    func adicionar(_ refeicao: Refeicao)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdiconaItensDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var itensTableView: UITableView?
    
    
    // MARK: - Atributos
    var tabelaDeRefeicao: AdicionaRefeicaoDelegate?
    var itens: [Item] = [Item(nome: "Molho de tomate", calorias: 40.0),
                         Item(nome: "Queijo", calorias: 40.0),
                         Item(nome: "Molho apimentado", calorias: 40.0)]
    
    var itensSelecionados: [Item] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet var nomeTextField: UITextField?
    @IBOutlet weak var felicidadeTextField: UITextField?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        let botaoAdiconaItem = UIBarButtonItem(title: "Adicionar", style: .plain, target: self, action: #selector(adicionarItens))
        navigationItem.rightBarButtonItem = botaoAdiconaItem
        
        do {
            guard let diretorio = recuperaDiretorio() else { return }
            let dados = try Data(contentsOf: diretorio)
            let itensSalvos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as! Array<Item>
            
            itens = itensSalvos
        }catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func adicionarItens() {
        let adicionatItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionatItensViewController, animated: true)
    }
    
    func add(_ item: Item) {
        itens.append(item)
        if let tableView = itensTableView {
            tableView.reloadData()
        } else {
            Alerta(controller: self).exibe(mensagem: "Nāo foi possível atualiza a tabela")
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: itens, requiringSecureCoding: false)
            guard let caminho = recuperaDiretorio() else { return }
            try data.write(to: caminho)
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func recuperaDiretorio() -> URL? {
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let caminho = diretorio.appending(path: "itens")
        
        return caminho
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let tableViewLine = indexPath.row
        let item = itens[tableViewLine]
        
        cell.textLabel?.text = item.nome
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        guard let celula = tableView.cellForRow(at: indexPath) else { return }
        
        if celula.accessoryType == .none {
            celula.accessoryType = .checkmark
            let tableViewLine = indexPath.row
            itensSelecionados.append(itens[tableViewLine])
        } else {
            celula.accessoryType = .none
            let item = itens[indexPath.row]
            if let position = itensSelecionados.firstIndex(of: item) {
                itensSelecionados.remove(at: position)
            }
        }
        
    }
    
    func recuperaRefeicaoDoFormulario() -> Refeicao? {
        guard let nomeDaRefeicao = nomeTextField?.text else {
            return nil
        }
        
        guard let felicidadeDaRefeicao = felicidadeTextField?.text, let felicidade = Int(felicidadeDaRefeicao) else {
            return nil
        }
        
        let refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidade, itens: itensSelecionados)
        refeicao.itens = itensSelecionados
        
        return refeicao
    }

    // MARK: - IBActions
    
    @IBAction func adicionar(_ sender: Any) {
        
        guard let refeicao = recuperaRefeicaoDoFormulario() else {return}
        tabelaDeRefeicao?.adicionar(refeicao)
        navigationController?.popViewController(animated: true)
        Alerta(controller: self).exibe(mensagem: "Erro ao ler dados do formulário")
    }
}
