//
//  RefeicoesTableViewController.swift
//  Food list
//
//  Created by Fabio Oliveira on 01/02/23.
//

import UIKit

class RefeicoesTableViewController: UITableViewController, AdicionaRefeicaoDelegate {
    
    var refeicoes = [Refeicao(nome: "Beringela", felicidade: 5),
                     Refeicao(nome: "Macarrão", felicidade: 3)]
    
    override func viewDidLoad() {
        guard let caminho = recuperaCaminho() else { return }
        do {
            let dados = try Data(contentsOf: caminho)
            guard let refeicoesSalvas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as? Array<Refeicao> else { return }
            refeicoes = refeicoesSalvas
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func recuperaCaminho() -> URL? {
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let caminho = diretorio.appending(path: "refeicao")
        
        return caminho
    }
    
    func adicionar(_ refeicao: Refeicao) {
        refeicoes.append(refeicao)
        tableView.reloadData()
        
        guard let caminho = recuperaCaminho() else { return }
        
        do {
            let dados = try NSKeyedArchiver.archivedData(withRootObject: refeicoes, requiringSecureCoding: false)
            try dados.write(to: caminho)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func mostrarDetalhes(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let cell = gesture.view as! UITableViewCell
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let refeicao = refeicoes[indexPath.row]
            
            RemoveRefeicaoViewController(controller: self).exibe(refeicao, handler: { alert in
                self.refeicoes.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
            
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let view = segue.destination as! ViewController
            view.tabelaDeRefeicao = self
        }
        
        // MARK: - UITableViewDataSource
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return refeicoes.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let linha = indexPath.row
            
            let refeicao = refeicoes[linha]
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = refeicao.nome
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mostrarDetalhes(_:)))
            cell.addGestureRecognizer(longPress)
            
            return cell
        }
    
}
