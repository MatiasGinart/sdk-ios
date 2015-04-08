# MercadoPago iOS (Swift) SDK
The MercadoPago iOS SDK make it easy to collect your users' credit card details inside your iOS app. By creating tokens, MercadoPago handles the bulk of PCI compliance by preventing sensitive card data from hitting your server.

It is developed for iOS 7 or sooner.

## Examples

![MercadoPagoSDK: Examples](https://raw.githubusercontent.com/mercadopago/sdk-ios/master/Screenshots/mercadopagosdk.png?token=AEMe-evtNJbwTxgKnHqB79kI889JOuxzks5VLocBwA%3D%3D)

## Installation

There are two ways to add MercadoPago to your project:

### Copy manually

- Open the MercadoPagoSDK folder, and drag MercadoPagoSDK.xcodeproj into the file navigator of your app project.
- In Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.
- Ensure that the deployment target of MercadoPagoSDK.framework matches that of the application target.
- In the tab bar at the top of that window, open the "Build Phases" panel.
- Expand the "Target Dependencies" group, and add MercadoPagoSDK.framework.
-Click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy - Frameworks", set the "Destination" to "Frameworks", and add MercadoPagoSDK.framework.

### CocoaPods

Coming soon.

Usage
-----
- Add import MercadoPagoSDK

        func initMercadoPagoVault() {
                let supportedPaymentTypes = ["credit_card", "debit_card", "prepaid_card"]
        
                let vaultViewController = MercadoPago.startVaultViewController("444a9ef5-8a6b-429f-abdf-587639155d88", 
                merchantBaseUrl: nil, merchantGetCustomerUri: nil, merchantAccessToken: nil, amount: 10.0, 
                supportedPaymentTypes: supportedPaymentTypes) { 
                (paymentMethod, token, cardIssuerId, installments) -> Void in
                        let alert = UIAlertController()
                        alert.title = "Payment Info"
                
                        var msg = "Token = \(token?.id!). \n Payment method = \(paymentMethod.name!). \n"
                        msg = msg + " Installments = \(installments!)."
                        msg = msg + " CardIssuer ID = \(cardIssuerId != nil ? cardIssuerId! : cardIssuerId)"
                
                        alert.message = msg
                        alert.addAction(UIAlertAction(title: "Finish", style: .Default, handler: { action in
                          switch action.style{
                            case .Default:
                              self.nav!.popToRootViewControllerAnimated(true)
                              self.nav!.popViewControllerAnimated(true)
                              self.initViewController()
                            case .Cancel:
                              println("cancel")
                            case .Destructive:
                              println("destructive")
                          }
                        }))
                        self.nav!.presentViewController(alert, animated: true, completion: nil)
                    }
                // Put vaultController at the top of navigator.
                self.nav!.pushViewController(vaultViewController, animated: false)
        }
