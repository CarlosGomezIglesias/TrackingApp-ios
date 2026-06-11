//
//  SignUpViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    //creamos las variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //creamos funcion de registrarse
    @IBAction func signUp(_ sender: Any) {
        //creamos las variables y si no las encuentra asignamos ""
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirm = passwordConfirmTextField.text ?? ""
        //si la contraseña no coincide lanza mensaje de error
        if password != passwordConfirm {
            let alert = UIAlertController(title: "Sign Up error", message: "Password do not match", preferredStyle: .alert)
            //se puede añadir que texto pone en el boton de la alerta
            //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton Ok
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) 
            self.present(alert, animated: true, completion: nil)
            return
        }
        //funcion que recibe el usuario y contraseña, y certifica que sen correctos
        Auth.auth().createUser(withEmail: username, password: password) { [unowned self] authResult, error in
            //si las variables username y password no son correctas, sale el mensaje
            guard error == nil else {
                print("Error creating user: \(error!)")
                //manda un mesaje de error con la descripcion de lo ocurrido, de tipo alerta
                let alert = UIAlertController(title: "Sign Up error", message: error!.localizedDescription, preferredStyle: .alert)
                //se puede añadir que texto pone en el boton de la alerta
                //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton Ok
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            createUser(withId: authResult!.user.uid)
            
            
            //si todo ha ido bien, lanza mensaje positivo
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
    func createUser(withId userId: String) {
        let username = usernameTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let gender = genderSegmentedControl.selectedSegmentIndex
        let birthDate = birthDatePicker.date.millisecondsSince1970 //esta en segundos, si hay que pasarlo a milisegundos se multiplica por 1000, para poder usarlo en android studio que si usa milisegundos
        
        let user = User(id: userId, username: username, firstName: firstName, lastName: lastName, gender: gender, birthDate: birthDate, profileImageUrl: nil)
        
        do {
            let db = Firestore.firestore()
            try db.collection("Users").document(userId).setData(from: user)
        } catch let error {
          print("Error writing user to Firestore: \(error)")
        }
      
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


