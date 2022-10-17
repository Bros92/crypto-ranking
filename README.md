
# Crypto Ranking App Info
## _Exercise 1_

Use this scheme to **release** the application with production configuration and to test the real flow of booking an appointment and conducting the test.
It contains the universal deeplink for **Otohub** team account.

I decided to apply this change to the code, to be conformed to coding design pattern:

- **Use Codable to encode and decode models**, to avoid to do this operation manually 
- **NetworkManager is too specialized**. The sigleton NetworkManager had some specific methods to make api request. I used a generic api request method to perform api request, using Codable models as Generics for decode. I also removed the parameter `isFetching` because this information should be saved inside the presenter, so it can manage correctly the business logics. 
- **I changed the class Foo in FooPresenter**. Foo manages the business logics of example, so i decide to apply the architectural pattern MVP and move all business logic in FooPresenter. It comunicates with the view through the view presenter. I also change the business logics for fetch and save methods. Following the logics inside the method `viewDidLoad()` of `FooViewController`, i noticed that these methods should be synch. So i decide to move the fetch methods inside the save methods and call it only after the api response and if it's necessary save the data on db (using a boolean parameter declared in method firm). The view model call on main thread the view presenter method to refresh the view and it doesn't wait the save db operatation because it's not useful to refresh view logic and because every UI update must be apply on main thread.
- **The FooViewController no longer handles logic**. It declare the View Presenter and it extends the FooViewPresenter to allow the comunication with the View Presenter 

## _Exercise 2_

For the second exercise, i didn't used third party libraries, so the project can run or build without install any package manager or other softwares.
I decice to use the architectural pattern MVVM because i wrote the app in SwiftUI. 
SwiftUI is based on declarative programming and using `Combine` framwork it's possibile to update view values properly.
So I decided to use MVVM because of the architectural patterns I know, it is the one that best suits declarative programming.

