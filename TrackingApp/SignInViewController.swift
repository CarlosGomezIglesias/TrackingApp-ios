//
//  ViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    //creamos las variables
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //si la el acceso ha sido correcto, navegar a home
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
            
        
    }
    
    
    
    //creamos funcion para cuando pinchamos en sign in
    @IBAction func signIn(_ sender: Any) {
        //creamos las variables y les asignamos "" si no las encuentra
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //funcion que recibe el usuario y contraseña, y certifica que sen correctos
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authResult, error in
            //si las variables username y password no son correctas, sale el mensaje
            guard error == nil else {
                print("Error creating user: \(error!)")
                //manda un mesaje de error con la descripcion de lo ocurrido, de tipo alerta
                let alert = UIAlertController(title: "Sign Up error", message: error!.localizedDescription,preferredStyle: .alert)
                //se puede añadir que texto pone en el boton de la alerta
                //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton Ok
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            //si todo es correcto navegamos a home
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
    }
}

