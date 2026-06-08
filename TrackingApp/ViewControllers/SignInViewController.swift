//
//  ViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

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
                print("Error signing In user: \(error!)")
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
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[unowned self] result, error in
            guard error == nil else {
                print("Error signIn with Google: \(error!)")
                //manda un mesaje de error con la descripcion de lo ocurrido, de tipo alerta
                let alert = UIAlertController(title: "Sign In with Google error", message: error!.localizedDescription,preferredStyle: .alert)
                //se puede añadir que texto pone en el boton de la alerta
                //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton Ok
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            guard let googleUser = result?.user, let idToken = googleUser.idToken?.tokenString else {
                print("Error getting token from Google: \(error!)")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleUser.accessToken.tokenString)
            //le decimos a firebase que nos loge con las credenciales
            Auth.auth().signIn(with: credential) { [unowned self] result, error in
                guard error == nil else {
                    print("Error signing In user: \(error!)")
                    //manda un mesaje de error con la descripcion de lo ocurrido, de tipo alerta
                    let alert = UIAlertController(title: "Sign In with Google error", message: error!.localizedDescription,preferredStyle: .alert)
                    //se puede añadir que texto pone en el boton de la alerta
                    //el handler seria la funcion lambda que quieres que ocurra cuando el usuario pulse el boton Ok
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //inicio Firestore
                Task {
                                    let userId = result!.user.uid
                                    
                                    let db = Firestore.firestore()
                                    let docRef = db.collection("Users").document(userId)
                                    
                                    do {
                                        let document = try await docRef.getDocument()
                                        
                                        if !document.exists {
                                            let username = result!.user.email ?? result!.user.phoneNumber ?? "usuario\(userId)"
                                            let firstName = googleUser.profile?.givenName ?? ""
                                            let lastName = googleUser.profile?.familyName ?? ""
                                            let profileImageUrl = googleUser.profile?.imageURL(withDimension: 400)?.absoluteString ?? nil
                                            
                                            let user = User(id: userId, username: username, firstName: firstName, lastName: lastName, gender: -1, birthDate: nil, profileImageUrl: profileImageUrl)
                                            
                                            try db.collection("Users").document(userId).setData(from: user)
                                        }
                                    } catch {
                                        print("Error creating user from Google: \(error)")
                                    }
                                    
                                    self.performSegue(withIdentifier: "NavigateToHome", sender: nil)
                                }
                
                //Navegar al home
                self.performSegue(withIdentifier: "NavigateToHome", sender: nil)
                //Fin firestore
                
               
            }
        }
    }
    @IBAction func signInWithFacebook(_ sender: Any) {
        
    }
    @IBAction func signInWithApple(_ sender: Any) {
        
    }
}

