//
//  SignUpViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirm = passwordConfirmTextField.text ?? ""
        
        if password != passwordConfirm {
            let alert = UIAlertController(title: "Sign Up error", message: "Password do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) { [unowned self] authResult, error in
            guard error == nil else {
                print("Error creating user: \(error!)")
                
                let alert = UIAlertController(title: "Sign Up error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "Sign Up", message: "Account created successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                //popViewcontroller cierra el controlador en el que estas y vuelve al anterior
                //poptorootviewcontroller cierra todos hasta que llega al primero
                //poptoviewcontroller le especificamos hasta que controller queremos volver y cierra los otros
                self.navigationController?.popViewController(animated: true)
            })) //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
